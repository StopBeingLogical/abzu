# General Prompts for AI-Assisted Development

These prompts are designed based on the existing architectural patterns and engineering standards found in the Mneme codebase (Concierge, Nisaba, Enki, etc.).

## 1. The "Quick Start" Prompt
Use this at the beginning of any session to ensure the model aligns with your project's specific "AI-ready" documentation.
> "I'm working on [Project Name]. Please read `CLAUDE.md` and the most recent session seed in `docs/seeds/` (if applicable) to understand our current sprint, locked specifications, and the session start checklist. Before we begin, ask if I want to consolidate entries from `.changelog/UNRELEASED.md`."

## 2. The "Architecture Guardrail" Prompt
Use this when asking for a new feature or refactor to ensure the model doesn't suggest over-engineered solutions or heavy dependencies.
> "We are following a 'Minimalist & Hand-rolled' philosophy for this project (similar to the Nisaba/Concierge stack). Avoid adding new dependencies, ORMs, or complex frameworks. Prioritize explicit composition over inheritance, and keep logic traceable and type-safe in [Go/Python/TS]."

## 3. The "Concierge-Style" Model Selection Prompt
Since you are building a system (Concierge) that relies on ensemble models, use this to evaluate how a task should be handled.
> "Considering the Concierge 'Wide not Deep' architecture: how would you decompose this task for a 7B-class specialist ensemble? Identify which parts require a 32B+ verifier and which parts can be handled by deterministic instruction-following models."

## 4. The "Homelab Deployment" Awareness Prompt
Use this when writing scripts or services that will run on your TrueNAS/Docker infrastructure.
> "This service will run on [Atlas/Daemon/Ergaster] in a Docker container. Ensure the solution respects our SQLite single-writer constraint (SetMaxOpenConns(1)), uses additive-only migrations, and handles networking for a Tailscale-based homelab environment."

## 5. The "Enki Validation" Prompt
Use this when you've finished a significant piece of logic or a new model-facing prompt.
> "Act as a validator using the Enki v1.0 framework. Decompose this implementation into subtasks, perform a self-assessment on potential failure points (like JSON formatting or token limits), and provide a semantic audit of the logic against our project's locked specifications."

## 6. The "Session Handoff" Prompt
Use this at the end of a session to prepare for your next interaction.
> "We are wrapping up this session. Please summarize our progress into a one-liner for `.changelog/UNRELEASED.md` and draft a brief 'Session Seed' update for the next model to load, focusing on current blockers and the 'Next Step' for [Project Component]."

---

## Architectural Principles to Enforce

*   **SQLite Single-Writer:** Always enforce `SetMaxOpenConns(1)` in Go/SQLite projects to avoid `SQLITE_BUSY` errors.
*   **Additive Migrations:** Database schema changes should be idempotent `ALTER TABLE ADD COLUMN` statements.
*   **Wide Not Deep:** Prefer multiple specialized models/functions over a single monolithic one.
*   **Hand-rolled UI:** Prioritize Go templates + HTMX + Tailwind (via CDN) for web interfaces to avoid complex build pipelines.
*   **SHA Auto-Correction:** When syncing files via API (like Forgejo), always fetch the current SHA before attempting updates/deletes to handle concurrency.


= = =

I am providing a set of data. Please process it according to the following instructions:

 1. Identify the core content of each entry.
 2. Categorize the entries based on the provided tags/headers.
 3. Structure the output in a clean, readable format (e.g., Markdown).

 Data:

 ---
 # Prompt: Template Transformer
 Use this prompt to transform raw notes into one of the following templates:
 - variation1.md (Delimiter-based)
 - variation2.md (Tag-first)
 - variation3.md

 I am providing a set of data. Please process it according to the following instructions:

 1. Identify the core content of each entry.
 2. Categorize the entries based on the provided tags/headers.
 3. Structure the output in a clean, readable format (e.g., Markdown).

 Data:
 [Insert Data Here]