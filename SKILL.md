---
name: md-to-pdf
description: |
  Convert a Markdown file into a beautifully typeset PDF via a pandoc → Typst pipeline.
  Ships with claude-white themes (warm white page, terracotta accents, serif typography).
  Trigger when the user says "turn this md into a pdf", "export X.md as pdf", "make X.md printable", or any request to produce a nicely formatted PDF from a Markdown file.
  Requires pandoc and typst installed. Fonts are bundled inside the skill directory — no system font installation needed.
---

# md-to-pdf

Convert Markdown into beautifully typeset PDFs. Use this skill whenever the user wants a polished PDF out of a Markdown source.

## Usage

```bash
./scripts/md_to_pdf.sh <input.md> <output.pdf> [theme]
```

Arguments:
- `input.md`: path to the Markdown file (absolute or relative)
- `output.pdf`: destination PDF path
- `theme`: theme name, defaults to `claude-white`. Available: `claude-white` (recommended), `claude-white-bold`

On success, the script prints `[OK] /absolute/path.pdf`.

## Architecture

```
md-to-pdf/
├── SKILL.md                           # this file
├── scripts/
│   └── md_to_pdf.sh                   # main pipeline: pandoc → sed → typst compile
├── themes/
│   ├── claude-white/              # default theme (recommended)
│   │   ├── DESIGN.md                  # design reference
│   │   ├── README.md                  # theme notes (typography, color tokens)
│   │   └── theme.typ                  # Typst template (show / set / color tokens)
│   └── claude-white-bold/         # variant with stronger synthetic bold
│       ├── DESIGN.md
│       ├── README.md
│       └── theme.typ
└── fonts/                             # bundled fonts loaded via typst --font-path
```

### Pipeline

1. `pandoc input.md --to typst` → `body.typ` (Typst body fragment, no template)
2. `perl` replaces `columns: N,` with `columns: (1fr,)*N,` so Markdown tables span the page width
3. `cat theme.typ body.typ > run.typ` (**must concatenate, not `#include`** — `#include` isolates scope and the body would lose access to `#let horizontalrule` and other theme definitions)
4. `typst compile --font-path <skill>/fonts run.typ output.pdf`

### Markdown elements styled by the theme

| Markdown | pandoc output | theme.typ |
|---|---|---|
| `# H1` | `= ...` | centered, 24pt bold |
| `## H2` / `### H3` / `#### H4` | `==` / `===` / `====` | bold, decreasing size, warming color |
| `**bold**` | `#strong[...]` | bold weight (or stroked synthetic bold in the `-bold` variant) |
| `*italic*` | `#emph[...]` | italic style |
| `` `code` `` | `` `code` `` | peach background + terracotta text |
| ` ```lang ``` ` | raw block | ivory background, rounded corners |
| `> quote` | `#quote(block: true)[...]` | warm-sand background, terracotta left bar |
| `- item` / `+ item` | `- ...` / `+ ...` | untouched |
| `[link](url)` | `#link(...)[...]` | terracotta + underline |
| `---` | `#horizontalrule` | thin warm-gray rule (defined via `#let horizontalrule = ...`) |
| table | `#figure(align(center)[#table(...)], kind: table)` | 1fr equal columns, 0.4pt warm borders, 1.2pt terracotta header underline |

## Adding a new theme

To add a new theme (e.g. `vercel` / `notion` / `mintlify`):

1. Create `themes/<name>/`
2. Optionally add `DESIGN.md` (design reference to translate from)
3. Write `theme.typ`: translate color tokens / typography / components into Typst `#set` + `#show` rules
4. Write `README.md`: record typography table and key decisions
5. Run: `./scripts/md_to_pdf.sh input.md output.pdf <name>`

`theme.typ` **must** include:
- all `#let` color tokens
- `#set page(...)` (with fill + footer)
- `#set text(...)` (font stack + size + color)
- `#set par(...)` (leading + justify)
- `#show heading.where(level: N): ...` for each heading level
- `#show strong / emph / link: ...`
- `#show raw.where(block: false/true): ...` (inline / block code)
- `#show quote.where(block: true): ...`
- `#set table(...)` + `#set table.hline(...)` + `#show figure.where(kind: table): ...`
- `#let horizontalrule = ...` (pandoc emits `#horizontalrule`, which Typst does not provide built-in)

## Dependencies

- **pandoc ≥ 3.2** — on PATH (tested with 3.9.0.2). The Typst writer was added in pandoc 3.2.
- **typst** — on PATH (tested with 0.14.2)
- **fonts** — bundled under `fonts/`; the script passes them via `typst compile --font-path`

If either binary is missing the script exits with a clear error (no silent fallback).

## Installing this skill into Claude Code

Clone this repo into your Claude Code skills directory:

```bash
git clone https://github.com/WeAIClub/md-to-pdf ~/.claude/skills/md-to-pdf
```

Claude Code will auto-discover the skill on next launch.

## Known limitations

- pandoc's Typst writer does not support every Markdown extension (comments, custom block containers, etc.)
- The bundled serif font has no native 700-weight glyphs, so Typst synthesizes bold from the 500-weight — it reads slightly lighter than a true bold. Use the `-bold` variant for stronger emphasis (stroke-based synthetic bold).
- Tables have no manual column-width control (uniform 1fr). For custom ratios, edit the intermediate `body.typ` manually.
