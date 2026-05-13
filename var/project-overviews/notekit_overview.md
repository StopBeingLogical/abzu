# Project NoteKit Overview

**NoteKit** is a native macOS note-taking application written in **Swift** and **SwiftUI**. It is designed to replicate the organizational hierarchy of Microsoft OneNote (**Notebooks → Sections → Pages**) but uses a lightweight, portable, and markdown-based approach.

### **Core Concept**
Unlike bloated modern note-taking apps, NoteKit focuses on being a clean, distraction-free repository for structured knowledge. Instead of a proprietary database, it stores all data in **portable ZIP files** containing Markdown files and JSON metadata, making it highly portable and easy to manage.

### **Key Features**
*   **Organizational Hierarchy:**
    *   **Notebooks:** Top-level containers (stored as `.zip` files).
    *   **Sections:** Folders within the notebook zip.
    *   **Pages:** Individual `.md` (Markdown) files.
*   **Advanced Versioning (Snapshots):**
    *   The app automatically creates a snapshot of the entire notebook when it is closed.
    *   Users can manually trigger a snapshot (`Cmd+Shift+S`).
    *   It includes a "Version History" feature to restore previous versions of a notebook.
*   **Powerful Search:**
    *   Full-text search across all open notebooks using a subprocess (like `grep` or `rg`).
    *   Results include "breadcrumbs" (e.g., `Notebook > Section > Page`) and text previews.
*   **Integration-Ready:**
    *   Designed to work with other tools in the user's ecosystem (specifically **Concierge** and **Castellan**).
    *   Supports appending content to existing pages via an API/direct write for automated task capture.
*   **Flexible Editing:**
    *   A dedicated Markdown editor (plain text, syntax highlighting, no WYSIWYG bloat).
    *   Can also act as a standalone markdown editor for loose `.md` files.

### **Technical Details**
*   **Platform:** macOS (Native)
*   **Language/Framework:** Swift / SwiftUI
*   **Storage Format:** 
    *   Notebooks are `.zip` files.
    *   Structure and metadata are stored in `metadata.json`, `notebook-structure.json`, and `section.json`.
*   **Data Location:** 
    *   Notebooks: `~/Library/Application Support/NoteKit/notebooks/`
    *   Snapshots: `~/.notebook-name/` (hidden directory)

### **Project Roadmap (MVP Goals)**
The development is divided into several sprints:
1.  **Core Data Model:** Implementing ZIP I/O and structure management.
2.  **UI Implementation:** Building the Sidebar (outline view), Editor, and Tab bar.
3.  **Editing & Page Ops:** Implementing Markdown editing, saving, and reordering.
4.  **Search & Navigation:** Implementing the `grep`-based search system.
5.  **Versioning:** Building the snapshot and restoration system.
