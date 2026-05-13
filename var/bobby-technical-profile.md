---
title: Bobby's Technical Profile
purpose: "Calibrate LLM communication to actual level — neither over-explain nor under-explain"
created: 2026-05-12
last_updated: 2026-05-12
tags: [user-profile, communication-preferences, technical-level]
---

# Technical Profile

## Self-Description
"Not greybeard darkroom hacker, not 'this is magic.'" Mid-to-senior generalist technologist. Strong systems thinker. Decade-plus across multiple computing roles.

## Strong / Comfortable
- Systems architecture (multi-machine, distributed, layered isolation)
- Hardware orchestration: homelab with mixed compute (CUDA, Apple Silicon, iGPU, CPU-only)
- Networking concepts: Tailscale mesh, ports, basic routing
- CLI tools, markdown, JSON, git basics
- Reading and following technical specs and design documents
- Model/AI concepts: ensemble voting, model families, parameter counts, quantization at a conceptual level
- Service install and config: Ollama, llama.cpp, similar local-model stacks
- High-level Go familiarity; can read most languages

## Less Familiar (Explain When They Come Up)
- Internals of specific data formats (NDJSON vs JSONL specifics, binary serialization details)
- Low-level systems-programming concepts (fsync semantics, kernel buffers, memory mapping, mmap, page cache)
- Framework internals (specific Go idioms beyond intermediate, particular library internals)
- Specialized subdomains (kernel work, DSP, low-level networking)

## Communication Preferences
- Don't explain general computing from first principles.
- Do explain implementation specifics that are foreign — name the technique, say what it does in plain language, move on.
- Brief plain-language definitions are right; over-elaboration is wrong.
- Use technical terms freely. If foreign, expect "what does X mean" as a follow-up rather than pre-emptive explanation every time.
- Specific > generic. "Tier 2 structured facts" beats "a structured store."
- Treat as colleague, not student.
- Match my vocabulary level back; don't dumb down once I've used a term.

## Environment
- **Logos**: MacBook M1 Max 64GB — primary workstation
- **Noesis**: portable Latitude — secondary
- **Homelab nodes**: mixed (Tesla P100, RTX 5060 Ti, headless Linux, TrueNAS)
- **Tailscale** mesh
- **Repos**: Forgejo (primary) + GitHub mirror
- **LLM access**: Anthropic Pro plan; OpenRouter (paid); local llama.cpp in homelab
- **Sync**: Nextcloud
- **Docs**: markdown-first

## Cognitive Profile (Actually The Important Part)
- AuDHD. Personal projects like Concierge are framed as cognitive prosthetic, not productivity tool.
- Strong on architecture and vision; weak on sustained low-interest implementation tedium.
- Hyperfocus-prone; benefits from systems that preserve context across sessions.
- Pattern-recognition over rote.
- Wants the system to handle mechanical follow-through so creative bandwidth stays free.
- "Surprise me" doesn't apply to taste decisions. Always applies to implementation technique.

## Current Exploration & Personal Style
**Learning Mode:** Self-taught, no formal CS education. Learns via building tools and discovering patterns, not studying abstractions. Currently in active exploration for personal development style.

**Aesthetic & Tools (May 2026):**
- Color: Tokyo Night everywhere (iTerm2, Starship, Windows Terminal, micro)
- Editor: micro for quick edits; vim-experienced, comfortable with modal editing. IDE not yet decided.
- Terminal: tmux with Tokyo Night
- Shells: zsh on Mac, bash on Linux (just defaults, not opinionated)
- Text: markdown-first, human-readable formats preferred

**Language Interest:**
- Go: Fascinated because it's versatile (can be used for anything); pragmatic, not domain-locked
- Swift: Pragmatic choice for Mac GUI (best available option, so why not)
- Rejected C#/.NET: Explicitly too cognitively heavy
- Philosophy: Avoids heavyweight ecosystems; low cognitive load prioritized

**Development Philosophy:**
- Would rather build custom tools to exact specifications than adopt large systems (e.g., building OneNote console clone instead of committing to Obsidian)
- Pending projects: OneNote console clone + custom static site generator
- Builds tools to learn; learning informs tool design

**Knowledge Gaps (Self-Aware):**
- Testing: Doesn't know how to approach correctly. Good candidate for learning via pending projects.
- Documentation: No formal strategy; understands markdown-first approach.
- Linting: Recently encountered the term; understands it as "code copy-editing"
- Dependencies: Concept understood practically but not formally
- API design: Has consumed APIs, never designed one
- Docker: Uses it, but deep understanding lacking
- Git: Pragmatic usage (CLI or VS Code), no formalized workflow or commit conventions
- Formal coding strategies: Unfamiliar with branching models, conventional practices

## How To Use This File
Load at session start when assisting Bobby. Reference it when calibrating explanation depth. Update when you observe a miscalibration (Bobby corrects either an over-explanation or an under-explanation). Pay special attention to: self-taught background (explain techniques plainly, avoid assuming formal CS knowledge), learning-via-building approach (suggest implementations over theory), and hyperfocus patterns (preserve context across sessions for pending projects).
