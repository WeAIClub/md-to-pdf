<h1 align="center">md-to-pdf</h1>

<p align="center"><em>markdown goes in, typography comes out</em></p>

<p align="center">
  <a href="https://github.com/WeAIClub/md-to-pdf/stargazers"><img src="https://img.shields.io/github/stars/WeAIClub/md-to-pdf?style=flat-square&color=c96442&labelColor=3d3d3a" alt="stars"></a>
  <a href="https://github.com/WeAIClub/md-to-pdf/commits/main"><img src="https://img.shields.io/github/last-commit/WeAIClub/md-to-pdf?style=flat-square&color=c96442&labelColor=3d3d3a" alt="last commit"></a>
  <a href="./LICENSE"><img src="https://img.shields.io/github/license/WeAIClub/md-to-pdf?style=flat-square&color=c96442&labelColor=3d3d3a" alt="license"></a>
</p>

<p align="center">
  <a href="#installation">Installation</a> ·
  <a href="#usage">Usage</a> ·
  <a href="#themes">Themes</a> ·
  <a href="#custom-themes">Custom themes</a> ·
  <a href="#architecture">Architecture</a>
  &nbsp;|&nbsp;
  <strong>English</strong> · <a href="./README.zh.md">中文</a>
</p>

---

<p align="center">
  <a href="./examples/sample.pdf">
    <img src="./examples/after.png" alt="A Markdown file rendered by md-to-pdf with the claude-white theme" width="900">
  </a>
  <br>
  <sub><i>A Markdown file rendered through md-to-pdf with the <code>claude-white</code> theme. Click for the full PDF.</i></sub>
</p>

A `pandoc → Typst` pipeline with pre-designed themes and bundled fonts — serif typography, terracotta accents, warm white page, no system font installation needed.

## Installation

You need **pandoc ≥ 3.2** (the Typst writer was added in 3.2) and **typst** on your `PATH`.

```bash
# macOS
brew install pandoc typst

# Linux (Arch)
sudo pacman -S pandoc typst

# Linux (Debian/Ubuntu): install pandoc via apt, typst from a release binary:
# https://github.com/typst/typst/releases
```

### Claude Code

Clone directly into Claude Code's skills directory:

```bash
mkdir -p ~/.claude/skills
git clone https://github.com/WeAIClub/md-to-pdf ~/.claude/skills/md-to-pdf
```

### OpenCode

```bash
mkdir -p ~/.config/opencode/skills
git clone https://github.com/WeAIClub/md-to-pdf ~/.config/opencode/skills/md-to-pdf
```

> **Note:** OpenCode also scans `~/.claude/skills/` for compatibility, so a single clone into `~/.claude/skills/md-to-pdf` works for both tools.

### Other agents

Any agent that can read a repo and run shell commands works — Gemini CLI, Codex CLI, Qoder, Cursor, and others. Clone the repo wherever you keep tools and point your agent at [`AGENTS.md`](./AGENTS.md), the short agent-facing spec.

## Usage

### Slash command

```
/md-to-pdf input.md output.pdf [theme]
```

`theme` is optional and defaults to `claude-white`. On success the script prints `[OK] /absolute/path.pdf`.

### Natural language

Just ask the agent in plain words — the skill picks itself up via its trigger description:

- "turn `report.md` into a pdf"
- "make `notes.md` printable with the `claude-white-bold` theme"
- "把 `report.md` 转成 PDF"
- "把这份笔记打印成 PDF，用 `claude-white-bold` 主题"

## Themes

| Theme | Notes |
|---|---|
| [`claude-white`](./themes/claude-white/) | **Recommended.** Warm white page, terracotta accents, serif typography. Soft synthetic bold — comfortable for body-heavy text. |
| [`claude-white-bold`](./themes/claude-white-bold/) | Same design language, but `**bold**` uses stroke-based synthetic bold for stronger emphasis. |

> 🚧 **More themes are on the way** — vercel, notion, linear, mintlify and friends are in the pipeline. Watch the repo or open an issue to request one.

## Custom themes

Adding a new theme is designed to be **fast**: you only need a `DESIGN.md` describing the look, and your AI agent writes the `theme.typ` for you.

### Step 1 — Drop in a `DESIGN.md`

Create `themes/<your-theme>/DESIGN.md`. This is a free-form Markdown file describing the look — color palette, typography stack, spacing, headings, code-block style, table style. You can paste any open-source design system spec (Vercel, Notion, Linear, Mintlify…) or write your own.

### Step 2 — Ask the agent to generate `theme.typ`

Open the repo in Claude Code (or any other coding agent) and say:

> Read `themes/claude-white/DESIGN.md` and `themes/claude-white/theme.typ` first, so you understand how a DESIGN.md is translated into a Typst theme file. Then read `themes/<your-theme>/DESIGN.md` and produce `themes/<your-theme>/theme.typ` following the same conventions.

The required hooks (`#set page`, `#show heading`, `#let horizontalrule`, etc.) are listed in [`SKILL.md`](./SKILL.md) — the agent should already pull from it.

### Step 3 — Use the new theme

```
/md-to-pdf input.md output.pdf <your-theme>
```

Or in natural language: *"turn `input.md` into a pdf using the `<your-theme>` theme"*.

If you build a theme worth sharing, PRs are welcome.

## Architecture

```
md-to-pdf/
├── SKILL.md                     # Skill entry (frontmatter + instructions)
├── AGENTS.md                    # Spec for non-Claude agents
├── README.md / README.zh.md     # Human docs
├── LICENSE                      # MIT (project code)
├── scripts/md_to_pdf.sh         # Main pipeline
├── themes/                      # One directory per theme
│   ├── claude-white/
│   │   ├── DESIGN.md            # design reference
│   │   ├── theme.typ            # Typst template
│   │   └── README.md            # typography notes
│   └── claude-white-bold/
├── fonts/                       # Bundled fonts + OFL license
└── examples/                    # sample.md + sample.pdf + screenshots
```

Pipeline:
1. `pandoc input.md --to typst` → Typst body fragment
2. Post-process `columns: N` → `columns: (1fr,)*N` so tables span the page
3. Concatenate `theme.typ + body.typ` into a single Typst file
4. `typst compile --font-path fonts/`

## License

Project code and themes: [MIT](./LICENSE).

Bundled fonts — [LXGW Bright GB](https://github.com/lxgw/LxgwBright) and [LXGW Bright Code GB](https://github.com/lxgw/LxgwBright-Code) by LXGW (陈亿堃): [SIL OFL 1.1](./fonts/LICENSE-LXGW.txt).

The `claude-white` theme draws its palette and typography from Anthropic's Claude design language; the source is preserved in `themes/claude-white/DESIGN.md`.
