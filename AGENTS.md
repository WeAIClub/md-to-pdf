# AGENTS.md

Guide for AI coding agents (Gemini CLI, Codex CLI, Qoder IDE, Cursor, etc.) to use this project.

## What this project does

Converts a Markdown file into a beautifully typeset PDF via a `pandoc → Typst` pipeline. Ships with two built-in themes (`claude-white` and `claude-white-bold`) and bundled fonts.

## When to use it

Invoke this tool when the user asks for any of:
- "turn this md into a pdf"
- "export X.md as pdf"
- "make X.md printable / presentable / nicely formatted"
- any request to produce a polished PDF from a Markdown source

## How to invoke

The main entry point is a single shell script:

```bash
./scripts/md_to_pdf.sh <input.md> <output.pdf> [theme]
```

- `input.md` — path to the Markdown file (absolute or relative)
- `output.pdf` — destination PDF path
- `theme` (optional) — defaults to `claude-white`. Also available: `claude-white-bold` (stronger bold)

Example:

```bash
./scripts/md_to_pdf.sh ./my-doc.md ./my-doc.pdf
./scripts/md_to_pdf.sh ./my-doc.md ./my-doc.pdf claude-white-bold
```

On success, prints `[OK] /absolute/path.pdf`.

## Preflight checks

Before invoking, confirm both dependencies are on PATH and pandoc is at least version 3.2 (the Typst writer was added in 3.2):

```bash
command -v pandoc && pandoc --version | head -1
command -v typst
```

If either is missing — or pandoc is older than 3.2 — tell the user to install / upgrade them (see README for platform-specific commands). The script will also error out with a clear message.

Fonts are **bundled in `fonts/`**; no system-font installation is needed — the script passes them to typst via `--font-path`.

## Platforms

- macOS and Linux: fully supported
- Windows: not officially supported (bash script); Git Bash or WSL should work but is not tested

## Adding a new theme

1. Create `themes/<your-theme>/theme.typ`
2. Define all required `#set` and `#show` rules (see `themes/claude-white/theme.typ` as reference)
3. Invoke with `./scripts/md_to_pdf.sh input.md output.pdf <your-theme>`
