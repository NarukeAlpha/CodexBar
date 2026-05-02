# CodexBar - OpenAI-only fork

Tiny macOS 14+ menu bar app that keeps Codex/OpenAI limits visible and shows when usage windows reset. This fork is intentionally scoped to OpenAI/Codex only; see [docs/OPENAI_ONLY_FORK.md](docs/OPENAI_ONLY_FORK.md) for the cleanup policy and upstream-porting notes.

<img src="codexbar.png" alt="CodexBar menu screenshot" width="520" />

## Install

### Requirements
- macOS 14+ (Sonoma)

### GitHub Releases
Download: <https://github.com/steipete/CodexBar/releases>

### Homebrew
```bash
brew install --cask steipete/tap/codexbar
```

### First run
- Install and sign in to Codex/OpenAI.
- Optional: Settings → Providers → Codex → OpenAI cookies (Automatic or Manual) to add dashboard extras.

## Providers

- [Codex](docs/codex.md) — OpenAI OAuth/cookie HTTP usage fetching, Codex CLI fallback, and optional OpenAI dashboard extras.

## Icon & Screenshot
The menu bar icon is a tiny two-bar meter:
- Top bar: 5‑hour/session window. If weekly is missing/exhausted and credits are available, it becomes a thicker credits bar.
- Bottom bar: weekly window (hairline).
- Errors/stale data dim the icon; status overlays indicate incidents.

## Features
- Codex/OpenAI usage meters with reset countdowns.
- Optional Codex web dashboard enrichments (code review remaining, usage breakdown, credits history).
- Local cost-usage scan for Codex (last 30 days).
- OpenAI status polling with incident badges in the menu and icon overlay.
- Refresh cadence presets (manual, 1m, 2m, 5m, 15m, 30m) with unchanged-data backoff.
- WidgetKit widget mirrors the menu card snapshot.
- Privacy-first: on-device parsing by default; browser cookies are opt-in and reused (no passwords stored).

## Privacy note
Wondering if CodexBar scans your disk? It doesn’t crawl your filesystem; it reads a small set of known locations (browser cookies/local storage, local JSONL logs) when the related features are enabled. See the discussion and audit notes in [issue #12](https://github.com/steipete/CodexBar/issues/12).

## macOS permissions (why they’re needed)
- **Full Disk Access (optional)**: only required to read Safari cookies/local storage for OpenAI dashboard extras. If you don’t grant it, use Chrome/Firefox cookies or CLI-only sources instead.
- **Keychain access (prompted by macOS)**:
  - Chrome cookie import needs the “Chrome Safe Storage” key to decrypt cookies.
  - **How do I prevent those keychain alerts?**
    - Open **Keychain Access.app** → login keychain → search the item.
    - Open the item → **Access Control** → add `CodexBar.app` under “Always allow access by these applications”.
    - Prefer adding just CodexBar (avoid “Allow all applications” unless you want it wide open).
    - Relaunch CodexBar after saving.
    - Reference screenshot: ![Keychain access control](docs/keychain-allow.png)
  - **How to do the same for the browser?**
    - Find the browser’s “Safe Storage” key (e.g., “Chrome Safe Storage”, “Brave Safe Storage”, “Firefox”, “Microsoft Edge Safe Storage”).
    - Open the item → **Access Control** → add `CodexBar.app` under “Always allow access by these applications”.
    - This removes the prompt when CodexBar decrypts cookies for that browser.
- **Files & Folders prompts (folder/volume access)**: CodexBar may launch the Codex CLI fallback. If the CLI reads a project directory or external drive, macOS may ask CodexBar for that folder/volume. This is driven by the CLI’s working directory, not background disk scanning.
- **What we do not request**: no Screen Recording, Accessibility, or Automation permissions; no passwords are stored (browser cookies are reused when you opt in).

## Docs
- OpenAI-only fork notes: [docs/OPENAI_ONLY_FORK.md](docs/OPENAI_ONLY_FORK.md)
- Providers overview: [docs/providers.md](docs/providers.md)
- Issue labeling guide: [docs/ISSUE_LABELING.md](docs/ISSUE_LABELING.md)
- UI & icon notes: [docs/ui.md](docs/ui.md)
- Architecture: [docs/architecture.md](docs/architecture.md)
- Refresh loop: [docs/refresh-loop.md](docs/refresh-loop.md)
- Status polling: [docs/status.md](docs/status.md)
- Sparkle updates: [docs/sparkle.md](docs/sparkle.md)
- Release checklist: [docs/RELEASING.md](docs/RELEASING.md)

## Getting started (dev)
- Clone the repo and open it in Xcode or run the scripts directly.
- Launch once, then configure Codex/OpenAI in Settings → Providers.
- Install/sign in to Codex/OpenAI.
- Optional: set OpenAI cookies (Automatic or Manual) for Codex dashboard extras.

## Build from source
```bash
swift build -c release          # or debug for development
./Scripts/package_app.sh        # builds CodexBar.app in-place
CODEXBAR_SIGNING=adhoc ./Scripts/package_app.sh  # ad-hoc signing (no Apple Developer account)
open CodexBar.app
```

Dev loop:
```bash
./Scripts/compile_and_run.sh
```

## Related
- ✂️ [Trimmy](https://github.com/steipete/Trimmy) — “Paste once, run once.” Flatten multi-line shell snippets so they paste and run.
- 🧳 [MCPorter](https://mcporter.dev) — TypeScript toolkit + CLI for Model Context Protocol servers.
- 🧿 [oracle](https://askoracle.dev) — Ask the oracle when you're stuck. Invoke GPT-5 Pro with a custom context and files.

## Looking for a Windows version?
- [Win-CodexBar](https://github.com/Finesssee/Win-CodexBar)

## Credits
Inspired by [ccusage](https://github.com/ryoppippi/ccusage) (MIT), specifically the cost usage tracking.

## License
MIT • Peter Steinberger ([steipete](https://twitter.com/steipete))
