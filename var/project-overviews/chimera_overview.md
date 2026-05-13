# Project Chimera Overview

**Project Chimera** is a high-fantasy, single-player RPG being built in **Go**. 

Its primary vision is to create a "Single-Player MUD" (Multi-User Dungeon) that functions as a graphical TUI (Terminal User Interface) application. It aims to capture the mechanical depth and atmospheric density of classic 90s Simutronics games (like *GemStone IV* or *DragonRealms*) but uses modern technology to create a more reactive, "living" world.

### **Core Pillars**
*   **Graphic Terminal Emulation:** Instead of a standard terminal, it uses **Ebitengine** to create a graphical window that mimics a terminal client, supporting features like clickable links and integrated graphics.
*   **Simutronics-Style Combat:** The combat system is driven by specific math, specifically the resolution of Attack Strength (AS) vs. Defensive Strength (DS).
*   **Agentic World:** A key feature is that every NPC operates as an independent process (a **Goroutine**), allowing them to follow individual schedules and offer context-sensitive quests.
*   **System-Gated Progression:** The game uses a "Metroidvania" approach to text-based exploration, where world traversal is gated by character stats (e.g., Climb, Swim, Perceive) and specific equipment.

### **Technical Stack**
*   **Language:** Go (version 1.22+)
*   **Engine:** Ebitengine (for 2D graphics and input handling)
*   **Data Format:** YAML (used for defining the world and entities)
*   **UI:** A custom TUI layout with various "viewports" for logs, stats, and graphics.
