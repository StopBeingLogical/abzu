# OpenRouter Free Text Models

| Model Name | Model Maker | Model Family | Purpose | Best Suitability |
|---|---|---|---|---|
| Tencent: Hy3 preview | Tencent | Hy3 | High-efficiency MoE LLM with configurable reasoning levels (disabled / low / high) | Production agentic workflows, code generation, and multi-step real-world tasks |
| NVIDIA: Nemotron 3 Super | NVIDIA | Nemotron | 120B MoE LLM (12B active) with 1M token context for multi-agent applications | Long-context reasoning, cross-document analysis, multi-agent systems, SWE-bench-class tasks |
| inclusionAI: Ling-2.6-1T | inclusionAI | Ling | Trillion-parameter MoE flagship optimized for fast agentic execution | Advanced coding, complex reasoning, and large-scale agent workflows prioritizing speed and cost efficiency |
| OpenAI: gpt-oss-120b | OpenAI | GPT-OSS | 117B open-weight MoE (5.1B active) with native tool use and structured output | High-reasoning agentic tasks, function calling, and structured output generation on a single H100 |
| Poolside: Laguna M.1 | Poolside | Laguna | Flagship coding agent with tool calling and reasoning (128K context) | Complex software engineering and long-horizon agentic coding workflows |
| Z.ai: GLM 4.5 Air | Z.ai | GLM | Lightweight MoE with switchable thinking and non-thinking inference modes | Fast agentic reasoning and tool use; configurable reasoning depth for real-time vs. deep tasks |
| MiniMax: MiniMax M2.5 | MiniMax | M2.5 | Productivity-focused LLM trained on office and browser environments | Coding, Office document generation (Word/Excel/PowerPoint), RAG, and multi-agent office workflows |
| NVIDIA: Nemotron 3 Nano 30B A3B | NVIDIA | Nemotron | Small fully-open MoE (3B active) for specialized agentic AI systems | Customizable agent deployment on constrained compute; privacy-sensitive and on-premise use cases |
| OpenAI: gpt-oss-20b | OpenAI | GPT-OSS | 21B open-weight MoE (3.6B active, Apache 2.0) with fine-tuning support | Low-latency inference on consumer or single-GPU hardware; agentic tool use with fine-tuning flexibility |
| Poolside: Laguna XS.2 | Poolside | Laguna | Compact second-generation coding agent (128K context, fp8 quantized) | Efficient agentic coding on limited resources where speed and cost matter |
| NVIDIA: Nemotron 3 Nano Omni | NVIDIA | Nemotron | 30B multimodal MoE accepting text, image, video, and audio input | Enterprise multimodal agent sub-systems processing diverse modalities in a single inference pass |
| Google: Gemma 4 31B | Google | Gemma 4 | 30.7B dense multimodal model with configurable reasoning (256K context) | Coding, reasoning, document understanding, and multilingual tasks (140+ languages) |
| NVIDIA: Nemotron Nano 12B 2 VL | NVIDIA | Nemotron | 12B multimodal model for video understanding and document intelligence | OCR, chart reasoning, long-form video comprehension, and document QA |
| NVIDIA: Nemotron Nano 9B V2 | NVIDIA | Nemotron | 9B LLM with configurable reasoning and non-reasoning modes | General assistant tasks with controllable chain-of-thought output |
| Google: Gemma 4 26B A4B | Google | Gemma 4 | 26B MoE multimodal model (3.8B active) with function calling (256K context) | Coding, reasoning, and multimodal understanding at near-31B quality for a fraction of the compute cost |
| LiquidAI: LFM2.5-1.2B-Thinking | LiquidAI | LFM | Lightweight 1.2B reasoning model for edge and agentic tasks (32K context) | Agentic tasks, data extraction, and RAG on edge or resource-constrained devices requiring chain-of-thought |
| Qwen: Qwen3 Coder 480B A35B | Qwen (Alibaba) | Qwen3 | 480B MoE code generation model (35B active) for agentic coding | Agentic coding, function calling, and long-context repository reasoning at scale |
| LiquidAI: LFM2.5-1.2B-Instruct | LiquidAI | LFM | Compact 1.2B instruction-tuned model for fast edge inference | Lightweight on-device chat and AI assistant applications where a tiny footprint is required |
| Qwen: Qwen3 Next 80B A3B Instruct | Qwen (Alibaba) | Qwen3 | 80B MoE instruction-tuned model optimized for stable, fast responses | RAG, tool use, agentic workflows, and long-context multi-turn dialogue where deterministic output is preferred |
| Baidu: Qianfan-OCR-Fast | Baidu | Qianfan | Domain-specific multimodal model purpose-built for OCR | Fast, high-accuracy optical character recognition from images and documents |
| Venice: Uncensored | Venice / dphn.ai | Dolphin / Mistral | Fine-tuned uncensored variant of Mistral-Small-24B with minimal content filtering | Creative writing, research, and applications requiring reduced safety restrictions |
| Google: Gemma 3n 2B | Google | Gemma 3n | Efficient multimodal model (effective 2B, based on 6B architecture) | Lightweight mobile or on-device inference with text, vision, and audio input |
| Google: Gemma 3n 4B | Google | Gemma 3n | Efficient multimodal model optimized for mobile and low-resource devices | On-device AI for phones and laptops; diverse multimodal tasks in resource-constrained environments |
| Google: Gemma 3 4B | Google | Gemma 3 | Multimodal instruction-tuned model with 128K context and 140+ language support | Lightweight multilingual chat, vision-language reasoning, and math on minimal infrastructure |
| Google: Gemma 3 12B | Google | Gemma 3 | Multimodal instruction-tuned model with 128K context and 140+ language support | Multilingual reasoning, math, coding, and vision-language tasks at mid-scale |
| Google: Gemma 3 27B | Google | Gemma 3 | Multimodal instruction-tuned model with 128K context and 140+ language support | Multilingual reasoning, math, coding, and vision-language tasks at larger scale |
| Meta: Llama 3.3 70B Instruct | Meta | Llama 3.3 | 70B multilingual instruction-tuned text-only model | General-purpose dialogue, reasoning, summarization, and multilingual chat |
| Meta: Llama 3.2 3B Instruct | Meta | Llama 3.2 | 3B multilingual instruction-tuned text-only model | Lightweight chat, summarization, and reasoning on edge or constrained hardware |
| Nous: Hermes 3 405B Instruct | Nous Research | Hermes 3 / Llama 3.1 | 405B generalist model with advanced agentic and roleplay capabilities | Long-context agentic workflows, complex multi-turn reasoning, and creative roleplay at maximum scale |

---

## Use Case Recommendations

### Rubber Duck Debugging
Best pick: **Nous: Hermes 3 405B Instruct** — explicitly built for multi-turn conversation, roleplay, and reasoning through problems. Runner-up: **Meta: Llama 3.3 70B Instruct** for a lighter, snappier back-and-forth.

### Coding
1. **Qwen: Qwen3 Coder 480B A35B** — purpose-built for agentic coding, function calling, and repo-level reasoning
2. **Poolside: Laguna M.1** — flagship coding agent, designed specifically for complex software engineering
3. **inclusionAI: Ling-2.6-1T** — top SWE-bench scores, strong on real-world engineering tasks
4. **Poolside: Laguna XS.2** — same as Laguna M.1 but lighter; good if you want faster responses for smaller tasks

### Planning and Project Breakdown
1. **NVIDIA: Nemotron 3 Super** — 1M token context window, explicitly designed for multi-step task planning and cross-document reasoning
2. **Qwen: Qwen3 Next 80B A3B Instruct** — stable, deterministic output; strong at RAG and structured agentic workflows
3. **MiniMax: M2.5** — trained in real-world productivity environments, good at breaking work across tasks and teams

### Summary

| Use Case | Top Pick | Why |
|---|---|---|
| Rubber Duck | Nous: Hermes 3 405B | Best multi-turn conversational reasoning |
| Coding | Qwen3 Coder 480B | Purpose-built for agentic code tasks |
| Planning | Nemotron 3 Super | 1M context + multi-step task planning |
