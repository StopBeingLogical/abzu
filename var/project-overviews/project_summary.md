# Project Summary: /home/bobby/nextcloud/AB4XSG

The directory `/home/bobby/nextcloud/AB4XSG` contains design documentation and technical primers for a 4X (eXplore, eXpand, eXploit, eXterminate) game project, referred to as both **"Minimal Web 4X"** and **"Space4X."**

The project appears to be a dual-track exploration of a turn-based strategy game engine, testing two different implementation paths:

### 1. The "Minimal Web 4X" Track (Ruby/Sinatra)
This path focuses on creating a lightweight, web-based prototype to validate the core engine loop and state management.
- **Tech Stack:** Ruby, Sinatra (Web App), YAML (Data/Content), and JSONL (Append-only logs).
- **Architecture:** A turn-based simulation engine where each authenticated user has an isolated single-player game instance stored directly on the filesystem.
- **Philosophy:** It prioritizes **determinism, inspectability, and data-driven design** while intentionally avoiding "heavy" technologies like complex databases or large web frameworks (like Rails) to keep the initial cognitive overhead low.

### 2. The "Space4X Core" Track (C#)
This path explores a more structured, strongly-typed approach for the engine core.
- **Tech Stack:** C#, with potential for UI integration using Godot or MonoGame.
- **Architecture:** A modular, subsystem-based design (Economy, Movement, Combat, World Generation) that uses deterministic seeds for reproducible game states.
- **Target Audience:** The documentation (`4x_csharp_core_primer.md`) is specifically written to make C# approachable for developers coming from PowerShell or BASIC backgrounds.

### Summary of Files
- **Design Documentation:** Multiple versions (`v0.1`, `v0.2`) of design specifications, rationales, and changelogs that define the "What" and "Why" of the project.
- **Technical Primers:** The `4x_csharp_core_primer.md` file serves as a walkthrough for building the C# core.
- **Brainstorming/Context:** `conversation.pdf` and `survival_rpgs_conversation.txt` appear to contain related discussions or brainstorming sessions that likely informed the project's direction.

In short, this is a highly organized **design study and prototype repository** for a turn-based strategy engine, testing different programming languages and architectures to find the best balance of simplicity, determinism, and scalability.
