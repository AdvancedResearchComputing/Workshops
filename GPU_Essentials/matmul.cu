// produced by an LLM for demonstration purposes only: YMMV 
#include <cublas_v2.h>
#include <cuda_runtime.h>
#include <iostream>
#include <vector>

#define CUDA_CHECK(x) do {                                            \
    cudaError_t e = (x);                                             \
    if (e != cudaSuccess) {                                          \
        std::cerr << "CUDA error: " << cudaGetErrorString(e) << "\n";\
        exit(1);                                                     \
    }                                                                \
} while (0)

#define CUBLAS_CHECK(x) do {                                         \
    cublasStatus_t s = (x);                                          \
    if (s != CUBLAS_STATUS_SUCCESS) {                                \
        std::cerr << "cuBLAS error: " << s << "\n";                  \
        exit(1);                                                     \
    }                                                                \
} while (0)

int main() {
    const int M = 2, N = 3, K = 4;   // A: MxK, B: KxN, C: MxN

    // Host matrices (row-major)
    std::vector<float> hA(M*K), hB(K*N), hC(M*N, 0.0f);
    for (int i = 0; i < M*K; ++i) hA[i] = static_cast<float>(i + 1);
    for (int i = 0; i < K*N; ++i) hB[i] = static_cast<float>(i + 1);

    // Device buffers
    float *dA, *dB, *dC;
    CUDA_CHECK(cudaMalloc(&dA, M*K*sizeof(float)));
    CUDA_CHECK(cudaMalloc(&dB, K*N*sizeof(float)));
    CUDA_CHECK(cudaMalloc(&dC, M*N*sizeof(float)));

    CUDA_CHECK(cudaMemcpy(dA, hA.data(), M*K*sizeof(float), cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(dB, hB.data(), K*N*sizeof(float), cudaMemcpyHostToDevice));

    // cuBLAS handle
    cublasHandle_t handle;
    CUBLAS_CHECK(cublasCreate(&handle));

    const float alpha = 1.0f, beta = 0.0f;

    // Row-major C = A*B  =>  column-major C^T = B^T * A^T
    // Pass (N, M, K) and swap A/B operands.
    CUBLAS_CHECK(cublasSgemm(handle,
                             CUBLAS_OP_N, CUBLAS_OP_N,
                             N, M, K,        // m=N, n=M, k=K
                             &alpha,
                             dB, N,          // B^T : leading dim = N
                             dA, K,          // A^T : leading dim = K
                             &beta,
                             dC, N));        // C^T : leading dim = N

    CUDA_CHECK(cudaMemcpy(hC.data(), dC, M*N*sizeof(float), cudaMemcpyDeviceToHost));

    // Print result
    std::cout << "C = A * B =\n";
    for (int i = 0; i < M; ++i) {
        for (int j = 0; j < N; ++j)
            std::cout << hC[i*N + j] << " ";
        std::cout << "\n";
    }

    CUBLAS_CHECK(cublasDestroy(handle));
    CUDA_CHECK(cudaFree(dA));
    CUDA_CHECK(cudaFree(dB));
    CUDA_CHECK(cudaFree(dC));
    return 0;
}
