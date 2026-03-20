# Using LLMs on ARC Systems

**Date:** 2026-03-19
**Presented by:** Ben Sandbrook (bsandbro@vt.edu)

[Spring 2026 ARC Workshop Schedule](https://github.com/AdvancedResearchComputing/Workshops/blob/main/README.md)

## Logistics


General Comments:
- Informal workshop so please feel free to interrupt me or use the chat for questions!
- This material is uploaded in our GitHub repo: [LLM_on_ARC_SYSTEMS](https://github.com/AdvancedResearchComputing/Workshops/tree/main/LLM_on_ARC_SYSTEMS)
- If you want to follow along, make sure you are connected to VT network (VPN if off campus) and have an ARC account

Useful links:
- ARC's documentation site: [https://docs.arc.vt.edu/](https://docs.arc.vt.edu/)
- ARC AI documentation: [https://docs.arc.vt.edu/zz_ai.html](https://docs.arc.vt.edu/zz_ai.html)
- GitHub Examples: [https://github.com/AdvancedResearchComputing/examples](https://github.com/AdvancedResearchComputing/examples)
- Office Hours: [https://arc.vt.edu/about/office-hours.html](https://arc.vt.edu/about/office-hours.html)
- 4Help: [https://arc.vt.edu/help](https://arc.vt.edu/help)

## Prerequisites

- An ARC account (apply at [https://coldfront.arc.vt.edu](https://coldfront.arc.vt.edu))
- Connected to VT network or VPN
- An API key from [https://llm.arc.vt.edu](https://llm.arc.vt.edu) (we'll walk through this together)

## Outline of this Workshop

1. (10 min) [What Are LLMs and Why Use Them on ARC?](#what-are-llms-and-why-use-them-on-arc)
2. (5 min) [Overview of ARC's AI Services](#overview-of-arcs-ai-services)
3. (5 min) [Setup: API Key and Jupyter on Open OnDemand](#setup-api-key-and-jupyter-on-open-ondemand)
4. (10 min) [Hands-On Part 1: The ARC LLM API](#hands-on-part-1-the-arc-llm-api)
5. (10 min) [Hands-On Part 2: Dedicated OOD LLM](#hands-on-part-2-dedicated-ood-llm)
6. (10 min) [Hands-On Part 3: Structured Output with pydantic-ai](#hands-on-part-3-structured-output-with-pydantic-ai)
7. (10 min) Q&A

___

# What Are LLMs and Why Use Them on ARC?

## Large Language Models (LLMs)

Large Language Models are AI systems trained on massive text datasets. They can answer questions, write code, summarize documents, and more. Common examples include ChatGPT, Claude, Gemini, and Kimi.

Under the hood, LLMs predict the next token (word or word-piece) in a sequence. They're built on a neural network architecture called the **Transformer**, which uses "attention" mechanisms to track relationships between words across an entire input. Training requires large amounts of GPU compute, often hundreds of GPUs running for weeks.

## Transformers

The **Transformer** is the neural network architecture that underlies virtually every modern LLM. Introduced in the 2017 paper *"Attention Is All You Need"*, it replaced earlier recurrent designs (Recurrent Neural Networks / RNNs, and Long Short-Term Memory networks / LSTMs) and made large-scale language modeling practical.

### How a Transformer Processes Text

1. **Tokenization**:  Input text is split into tokens (words or sub-words). Each token is mapped to a high-dimensional vector called an *embedding*.
2. **Positional encoding**:  Since a Transformer processes all tokens simultaneously (not one at a time), it has no built-in sense of order. To fix this, a positional encoding vector is added to each token's embedding before it enters the attention layers. The original paper used fixed sine and cosine waves of different frequencies — each position in the sequence gets a unique pattern of values. Modern models often use learned positional embeddings or more sophisticated schemes (like Rotary Position Embedding / RoPE), but the goal is the same: let the model distinguish "the word *cat* at position 3" from "the word *cat* at position 17".
3. **Self-attention**:  Each token looks at every other token in the input and computes a weighted sum. Tokens that are semantically related get high attention weights. This is what lets the model resolve ambiguity, link pronouns to their referents, and capture long-range dependencies.
4. **Feed-forward layers**:  After attention, each token embedding passes through a small multi-layer perceptron that applies a non-linear transformation.
5. **Stacking layers**:  Steps 3–4 are repeated many times (e.g., 96 layers in GPT-4). Each layer refines the representations built by the previous one.
6. **Output head**:  The final embeddings are projected onto a vocabulary-sized vector, and a softmax turns those scores into a probability distribution over the next token.

### Why Attention Matters

Earlier sequence models processed tokens one at a time, making it hard to connect information across long distances. Self-attention computes relationships between *all* pairs of tokens in a single step, giving the model a global view of the context window. This is also what makes Transformers highly parallelizable on GPUs.

### Scale and the Emergence of LLMs

A Transformer becomes an LLM when trained at scale:
- **Parameters**: billions of learned weights (e.g., Llama 3 70B has 70 billion)
- **Data**: trillions of tokens from the web, books, and code
- **Compute**: thousands of GPUs running for weeks to months

At sufficient scale, emergent capabilities appear (reasoning, code generation, in-context learning) that are not present in smaller models.

## Why Use LLMs on ARC?

Commercial LLM services like ChatGPT send your data to third-party servers. ARC's LLM services are different:

- All processing happens on-premises at VT. No data leaves the university.
- The service is approved for high-risk data (consult VT's Privacy and Research Data Protection Program for regulatory details).
- The centralized API is free. There is no charge to individual users.
- You get API access, so you can call LLMs from Python scripts, notebooks, or data pipelines.
- 40+ open-source models are available, including models optimized for code, reasoning, and multimodal tasks.
- Through Open OnDemand, you can run your own private LLM on a dedicated GPU with no rate limits.

___

# Overview of ARC's AI Services

ARC provides three ways to interact with LLMs. Each serves a different use case:

## 1. llm.arc.vt.edu (Web Chat Interface)

A browser-based chat interface (built on Open WebUI) for conversational interaction with LLMs. Available at [https://llm.arc.vt.edu](https://llm.arc.vt.edu) to all VT students, faculty, and staff. No ARC account required.

Features include chat, web search, document upload (RAG), and image generation. Available models:

- `gpt-oss-120b`: fast general-purpose responses
- `Kimi-K2.5`: complex tasks and multimodal work
- `MiniMax-M2.5`: optimized for software engineering tasks

> **Tip:** This is also where you generate your API key for programmatic access. Click your profile icon (top right) > **Settings** > **Account** > **API keys** > **Show**.

## 2. llm-api.arc.vt.edu (Centralized API)

An OpenAI-compatible REST API for programmatic access to the same models available on llm.arc.vt.edu.

- Base URL: `https://llm-api.arc.vt.edu/api/v1`
- Authentication: Bearer token using your API key from llm.arc.vt.edu
- Rate limits: 60 requests/min, 1,000/hour, 3,000 per 3-hour window
- Features: Chat completions, web search, document upload/RAG, image generation, vision

Because the API is OpenAI-compatible, you can use the standard `openai` Python library. Just change the `base_url` to point at ARC's servers.

## 3. Open OnDemand (Dedicated LLM)

Launch your own private LLM instance on a GPU via Open OnDemand.

- URL: [https://ood.arc.vt.edu](https://ood.arc.vt.edu) > Interactive Apps > LLMs
- Backend: llama.cpp
- API: OpenAI-compatible (unique API key generated per session)
- Rate limits: None (you have exclusive access to the GPU)
- Session limit: Max 5 days; auto-terminates after 1 hour of inactivity

> **Note:** The centralized API (llm-api) is free and shared among all users with rate limits. The OOD dedicated LLM gives you exclusive GPU access with no rate limits, but consumes service units (SUs) from your allocation.

___

# Setup: API Key and Jupyter on Open OnDemand

## Step 1: Generate Your API Key

1. Open [https://llm.arc.vt.edu](https://llm.arc.vt.edu) in your browser
2. Log in with your VT credentials
3. Click your profile icon (top right) > **Settings** > **Account**
4. Scroll to **API keys** and click **Show**
5. Copy the key (it starts with `sk-`) and save it somewhere safe

> **Warning:** Treat your API key like a password. Do not share it, commit it to git, or paste it into shared documents.

## Step 2: Launch Jupyter Notebook on Open OnDemand

1. Open [https://ood.arc.vt.edu](https://ood.arc.vt.edu) in your browser
2. Go to **Interactive Apps** > **Jupyter Notebook**
3. Configure your session:
   - Partition: `normal_q` (a GPU is not needed for API access)
   - Number of cores: 1
   - Memory (GB): 4
   - Wall time: 2 hours
   - Account: your allocation account
4. Click **Launch** and wait for the session to start
5. Click **Connect to Jupyter** when the button appears

___

# Hands-On Part 1: The ARC LLM API

In this section we'll work through the workshop notebook together. Follow along in your own Jupyter session.

The notebook walks through:

1. **Installing the OpenAI library** and creating a client pointed at ARC's API
2. **Your first chat completion** with system and user messages
3. **Exploring the response object** (model name, token counts)
4. **Changing behavior with the system prompt** (same question, different personas)
5. **Exercise: try your own prompt**
6. **Web search** using `tool_ids` to let the model look up current information
7. **Multi-turn conversations** by passing the full message history each time

___

# Hands-On Part 2: Dedicated OOD LLM

## Why Use a Dedicated LLM?

The centralized API is great for prototyping, but has rate limits (60 requests/min). If you need to:
- Process hundreds or thousands of prompts in a batch
- Work with a specific model not available on the centralized API
- Have guaranteed response times without sharing resources

...then a dedicated LLM is the way to go.

## Launching a Dedicated LLM

1. Open [https://ood.arc.vt.edu](https://ood.arc.vt.edu) in a **new browser tab** (keep your Jupyter session running)
2. Go to **Interactive Apps** Large Language Model> ****
3. Configure your session:
   - Select a model from the dropdown
   - Account: your allocation account
   - Number of hours
4. Click **Launch** and wait for the session to start
5. When the session is running, note the and **API key** shown on the session card, copy it and click connect.
6. Once the model finishes loading, enter the API key to access the web UI.

> **Warning:** The OOD LLM session consumes service units from your allocation while it runs. Always **delete the session** when you're done. Simply closing the browser tab does NOT stop the job. There is also an **idle timeout of 1 hour**, if no activity is detected, the job will be canceled to reclaim the resources for others.

## Connecting from the Notebook

Back in the workshop notebook, we create a second client that points at the OOD LLM session. The code is the same — just a different URL and API key — but there's a networking wrinkle: our Jupyter session runs on **TinkerCliffs** while the OOD LLM runs on a **Falcon** GPU node, and the two clusters can't talk to each other directly. The notebook handles this automatically by setting up an **SSH tunnel** through `falcon1.arc.vt.edu` to bridge the connection. You just paste in the OOD connection URL and API key, and the tunnel is created behind the scenes.

The notebook then lists available models, makes a chat completion, and times a side-by-side comparison of both services.

## A Note on vLLM

For truly massive workloads (tens of thousands of prompts), ARC also supports [vLLM](https://docs.arc.vt.edu/ai/030_vllm.html), a high-throughput inference engine you can launch via Slurm. It excels at batch processing and can spread a model across multiple GPUs with tensor parallelism. However, an equivalent model will generally need more GPU memory — a model that fits on one GPU with llama.cpp may require two or more with vLLM. It also requires more hands-on setup (writing Slurm scripts, managing the server) compared to the OOD point-and-click app. Pre-downloaded models are available at `/common/data/models/`.

___

# Hands-On Part 3: Structured Output with pydantic-ai

## Why Structured Output?

Plain text responses are fine for chat, but if you want to use LLM output in code (store it in a database, feed it to another function, build a pipeline), you need structured data. Parsing free-form text with regex is fragile.

**Pydantic** is a Python library for defining data schemas as classes with typed fields. **pydantic-ai** connects this to an LLM: you define a Pydantic class as the output type, and the LLM is forced to return a valid instance. You get back a Python object, not a string.

## The Debate Club Demo

The notebook sets up three LLM agents using pydantic-ai, all powered by **gpt-oss-120b**:

- One argues FOR a topic
- One argues AGAINST
- One judges and declares a winner

Each response comes back as a structured `DebateArgument` (with `argument`, `evidence`, `snark_level`, `confidence`) or `Verdict` (with `winner`, `reasoning`, `score_for`, `score_against`, `best_moment`). The audience picks the topic.

This demonstrates structured output in a way that's fun to watch, while showing a pattern that's useful for research: extracting metadata from papers, generating configs, building data pipelines, or any case where you need LLM output you can trust to match a schema.

___

# Wrap-Up and Resources

## Key Takeaways

- ARC's LLM services are free and on-premises. No data leaves Virginia Tech.
- llm.arc.vt.edu is the quickest way to start (web chat, no setup)
- llm-api.arc.vt.edu gives you API access using the standard `openai` Python library
- OOD dedicated LLMs give you a private GPU with no rate limits (costs SUs)
- pydantic-ai lets you get structured, typed Python objects back from any LLM

## Best Practices

- If sharing or committing notebooks, pull API keys from environment variables instead of pasting them inline
- Start with the centralized API for development and prototyping (it's free)
- Switch to a dedicated OOD LLM when you need batch processing or no rate limits
- Always delete your OOD LLM sessions when done to free up resources and stop SU consumption
- Consult VT's data classification policies before processing sensitive research data

## Resources

- ARC AI documentation: [https://docs.arc.vt.edu/zz_ai.html](https://docs.arc.vt.edu/zz_ai.html)
- ARC general documentation: [https://docs.arc.vt.edu](https://docs.arc.vt.edu)
- ARC Office Hours: [https://arc.vt.edu/about/office-hours.html](https://arc.vt.edu/about/office-hours.html)
- ARC Support / 4Help: [https://arc.vt.edu/help](https://arc.vt.edu/help)
- Allocation management: [https://coldfront.arc.vt.edu](https://coldfront.arc.vt.edu)
