// t4_gemm_bench.cu
// Large cuBLAS GEMM benchmark tuned for NVIDIA T4 (sm_75)
// Build: nvcc -O3 -arch=sm_75 t4_gemm_bench.cu -lcublas -o t4_gemm_bench
// produced by an LLM for demonstration purposes only: YMMV 

#include <cublas_v2.h>
#include <cuda_runtime.h>
#include <cuda_fp16.h>
#include <cstdio>
#include <cstdlib>
#include <vector>
#include <string>

#define CUDA_CHECK(x) do {                                            \
    cudaError_t e = (x);                                             \
    if (e != cudaSuccess) {                                          \
        fprintf(stderr, "CUDA error %s:%d: %s\n",                    \
                __FILE__, __LINE__, cudaGetErrorString(e));          \
        exit(EXIT_FAILURE);                                          \
    }                                                                \
} while (0)

#define CUBLAS_CHECK(x) do {                                         \
    cublasStatus_t s = (x);                                          \
    if (s != CUBLAS_STATUS_SUCCESS) {                                \
        fprintf(stderr, "cuBLAS error %s:%d: code %d\n",             \
                __FILE__, __LINE__, (int)s);                         \
        exit(EXIT_FAILURE);                                          \
    }                                                                \
} while (0)

// ---------- timing helpers ----------
struct GpuTimer {
    cudaEvent_t start, stop;
    GpuTimer()  { cudaEventCreate(&start); cudaEventCreate(&stop); }
    ~GpuTimer() { cudaEventDestroy(start); cudaEventDestroy(stop); }
    void begin() { cudaEventRecord(start); }
    float end() {                       // returns elapsed milliseconds
        cudaEventRecord(stop);
        cudaEventSynchronize(stop);
        float ms = 0.f;
        cudaEventElapsedTime(&ms, start, stop);
        return ms;
    }
};

// 2*M*N*K flops per GEMM
static double gflops(int M, int N, int K, float ms) {
    return (2.0 * M * N * K) / (ms * 1e-3) / 1e9;
}

// ---------- device query ----------
static void printDeviceInfo() {
    cudaDeviceProp p;
    CUDA_CHECK(cudaGetDeviceProperties(&p, 0));
    printf("Device: %s  (sm_%d%d)\n", p.name, p.major, p.minor);
    printf("  SMs: %d | Global mem: %.1f GB | Clock: %.2f GHz\n",
           p.multiProcessorCount,
           p.totalGlobalMem / (1024.0*1024*1024),
           p.clockRate * 1e-6);
    printf("  Memory bandwidth: %.0f GB/s (theoretical)\n\n",
           2.0 * p.memoryClockRate * 1e3 * (p.memoryBusWidth / 8) / 1e9);
}

// ---------- FP32 SGEMM ----------
template <typename T>
static void fillRandom(T* d, size_t n);

template <>
void fillRandom<float>(float* d, size_t n) {
    std::vector<float> h(n);
    for (size_t i = 0; i < n; ++i) h[i] = (rand() / (float)RAND_MAX) - 0.5f;
    CUDA_CHECK(cudaMemcpy(d, h.data(), n*sizeof(float), cudaMemcpyHostToDevice));
}
template <>
void fillRandom<__half>(__half* d, size_t n) {
    std::vector<__half> h(n);
    for (size_t i = 0; i < n; ++i)
        h[i] = __float2half((rand() / (float)RAND_MAX) - 0.5f);
    CUDA_CHECK(cudaMemcpy(d, h.data(), n*sizeof(__half), cudaMemcpyHostToDevice));
}

static void benchSgemm(cublasHandle_t handle, int M, int N, int K, int iters) {
    size_t szA = (size_t)M*K, szB = (size_t)K*N, szC = (size_t)M*N;
    float *dA, *dB, *dC;
    CUDA_CHECK(cudaMalloc(&dA, szA*sizeof(float)));
    CUDA_CHECK(cudaMalloc(&dB, szB*sizeof(float)));
    CUDA_CHECK(cudaMalloc(&dC, szC*sizeof(float)));
    fillRandom<float>(dA, szA);
    fillRandom<float>(dB, szB);

    const float alpha = 1.0f, beta = 0.0f;
    // Row-major C=A*B  ->  column-major swap trick: (N,M,K)
    auto run = [&]{
        CUBLAS_CHECK(cublasSgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N,
                                 N, M, K,
                                 &alpha, dB, N, dA, K, &beta, dC, N));
    };

    run(); CUDA_CHECK(cudaDeviceSynchronize());  // warmup

    GpuTimer t; t.begin();
    for (int i = 0; i < iters; ++i) run();
    float ms = t.end() / iters;

    printf("  [FP32 SGEMM] %5d x %5d x %5d : %8.3f ms  %8.1f GFLOP/s\n",
           M, N, K, ms, gflops(M,N,K,ms));

    CUDA_CHECK(cudaFree(dA));
    CUDA_CHECK(cudaFree(dB));
    CUDA_CHECK(cudaFree(dC));
}

// ---------- FP16 tensor-core GEMM ----------
static void benchHgemmTensor(cublasHandle_t handle, int M, int N, int K, int iters) {
    size_t szA = (size_t)M*K, szB = (size_t)K*N, szC = (size_t)M*N;
    __half *dA, *dB, *dC;
    CUDA_CHECK(cudaMalloc(&dA, szA*sizeof(__half)));
    CUDA_CHECK(cudaMalloc(&dB, szB*sizeof(__half)));
    CUDA_CHECK(cudaMalloc(&dC, szC*sizeof(__half)));
    fillRandom<__half>(dA, szA);
    fillRandom<__half>(dB, szB);

    // Enable tensor-core math path
    CUBLAS_CHECK(cublasSetMathMode(handle, CUBLAS_TENSOR_OP_MATH));

    const __half alpha = __float2half(1.0f);
    const __half beta  = __float2half(0.0f);

    // Row-major via GemmEx swap trick: (N,M,K)
    auto run = [&]{
        CUBLAS_CHECK(cublasGemmEx(handle,
            CUBLAS_OP_N, CUBLAS_OP_N,
            N, M, K,
            &alpha,
            dB, CUDA_R_16F, N,
            dA, CUDA_R_16F, K,
            &beta,
            dC, CUDA_R_16F, N,
            CUBLAS_COMPUTE_16F,                 // FP16 accumulate (fastest on T4)
            CUBLAS_GEMM_DEFAULT_TENSOR_OP));
    };

    run(); CUDA_CHECK(cudaDeviceSynchronize());  // warmup

    GpuTimer t; t.begin();
    for (int i = 0; i < iters; ++i) run();
    float ms = t.end() / iters;

    printf("  [FP16 HGEMM] %5d x %5d x %5d : %8.3f ms  %8.1f GFLOP/s\n",
           M, N, K, ms, gflops(M,N,K,ms));

    CUBLAS_CHECK(cublasSetMathMode(handle, CUBLAS_DEFAULT_MATH));
    CUDA_CHECK(cudaFree(dA));
    CUDA_CHECK(cudaFree(dB));
    CUDA_CHECK(cudaFree(dC));
}

int main(int argc, char** argv) {
    printDeviceInfo();

    cublasHandle_t handle;
    CUBLAS_CHECK(cublasCreate(&handle));

    // T4 has ~16 GB. These sizes are comfortable but exercise real bandwidth/compute.
    const int sizes[][3] = {
        {2048, 2048, 2048},
        {4096, 4096, 4096},
        {8192, 8192, 8192},
        {8192, 8192, 2048},   // "skinny"/tall shapes are common in DL
        {16384, 16384, 1024},
    };

    for (auto& s : sizes) {
        int M = s[0], N = s[1], K = s[2];
        // Scale iterations down as matrices grow so total time stays bounded
        int iters = (M*N*K <= (1<<30)) ? 20 : 5;
        printf("=== %d x %d x %d (iters=%d) ===\n", M, N, K, iters);
        benchSgemm(handle, M, N, K, iters);
        benchHgemmTensor(handle, M, N, K, iters);
        printf("\n");
    }

    CUBLAS_CHECK(cublasDestroy(handle));
    CUDA_CHECK(cudaDeviceReset());
    return 0;
}
