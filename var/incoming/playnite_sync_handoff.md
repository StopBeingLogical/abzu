# Project Handoff: Playnite-to-Web-App Library Sync

## Project Overview
The goal is to synchronize a local gaming library aggregated via **Playnite** (Windows) with a custom **Web Application** via an API. The user has successfully installed Playnite and linked accounts (Amazon, GOG, Steam, etc.) and is now seeking to automate the data extraction to populate their web-based collection manager.

## Technical Context
- **Source Environment:** Playnite (Local Windows Installation).
- **Target Environment:** Custom Web Application (API-enabled).
- **Operating Mode:** Exploratory/Learning Mode (focusing on understanding architecture and SDK).
- **Core Requirement:** Extract game metadata (Title, Platform, Source, Playtime) and POST it to a web endpoint.

## Integration Strategies Explored
1.  **Playnite SDK / PowerShell:** Using the built-in `$PlayniteApi` to iterate through the database and dispatch JSON payloads via `Invoke-RestMethod`.
2.  **Plugin Development (C#):** Building a native extension for more robust, event-driven syncing (e.g., triggering on library updates).
3.  **Filesystem Parsing:** Direct ingestion of JSON files located in `%AppData%\Playnite\library\games`.

## Current Status
- Playnite is configured and accounts are synced.
- The user is evaluating which integration method to prioritize.
- A basic PowerShell prototype has been discussed for initial testing.

## Immediate Next Steps for gemini-cli
1.  **Schema Mapping:** Define the JSON structure required by the Web App's API and map it to Playnite's `Game` object properties.
2.  **Script Development:** Provide a robust PowerShell script or C# boilerplate to handle batch updates and error handling for the API calls.
3.  **Automation:** Determine the best trigger mechanism (e.g., Playnite's `OnLibraryUpdated` event or a scheduled task).

## Reference Data
- **Local Database Path:** `%AppData%\Playnite\library\`
- **Key API Objects:** `PlayniteApi.Database.Games`, `Game.Source`, `Game.Platforms`
