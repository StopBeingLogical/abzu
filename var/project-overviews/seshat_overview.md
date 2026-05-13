# Seshat Project Overview

The project in `/home/bobby/nextcloud/0_to_process/Work (Personal)/projects/seshat` is called **Seshat**.

### **Project Overview**
**Seshat** is a centralized repository of "AI context seeds" and canonical reference documents. Its primary purpose is to provide AI assistants with consistent, high-fidelity context when working with the user (Bobby). Because Bobby works across multiple AI platforms (Claude, Gemini, local models), Seshat acts as a "source of truth" to ensure that every AI assistant understands his preferences, naming conventions, hardware setup, and current project states.

### **Core Components**
The repository is structured around several key documentation files that an AI is expected to ingest:

*   **`bootstrap.md` (The Bootstrap Protocol):** A mandatory startup sequence for any AI assistant. It instructs the AI on how to initialize its context (e.g., fetching preferences, naming conventions, and current state) before starting work.
*   **`preferences.md`:** Defines Bobby's collaboration style, working preferences, and security guardrails.
*   **`naming.md`:** Establishes the naming conventions used across all projects and assets.
*   **`current.md`:** Maintains the "last known session state," allowing an AI to pick up exactly where a previous session left off.
*   **`glossary.md`:** A mapping of terms to their specific roles and physical/logical locations.
*   **`hardware.md`:** Details the specifications, roles, and status of physical hardware nodes.
*   **`infrastructure.md`:** Describes the data topology, replication patterns, and "source of truth" locations for files and deployments.
*   **`projects.md`:** A high-level index of active software projects and infrastructure.

### **Workflow for AI Assistants**
When an AI assistant interacts with this environment, it is instructed to follow a specific sequence:
1.  **Determine capabilities** (check for shell/filesystem access).
2.  **Read `preferences.md`** to understand how to communicate.
3.  **Read `naming.md`** to ensure correct terminology.
4.  **Read `current.md`** to understand the current task status.
5.  **Identify the active project** via `projects.md` and fetch its specific `SESSION_SEED.md` for deep technical context.

In short, **Seshat is a "memory management" system for AI-driven development**, ensuring that the AI is always "up to speed" with the user's ecosystem.
