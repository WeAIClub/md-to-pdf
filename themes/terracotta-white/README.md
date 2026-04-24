# terracotta-white

The default theme. Pure white page, terracotta accents, serif typography.

## Characteristics

- **Background**: Pure White `#ffffff` (clean page, no aged/parchment feel)
- **Typography**: Serif body and headings, monospace for code (uses bundled fonts from `fonts/`)
- **Primary accent**: Terracotta `#c96442` — H2 left bar, inline code text, links, table header divider
- **Headings**: H1 centered 24pt bold; H2 16pt bold with terracotta left bar; H3 13pt bold; H4 11pt bold
- **Tables**: all cells framed in 0.4pt warm-gray; a 1.2pt terracotta divider under the header row; columns are evenly `1fr` split (the pipeline rewrites `columns: N` → `columns: (1fr,)*N`)
- **Inline code / filename highlight**: peach `#fbe3d3` background + terracotta text
- **Bold**: uses Typst's default `weight: bold`. With the bundled serif (no native 700), the rendered bold is a soft synthetic bold. If you want stronger emphasis, use `terracotta-white-bold` instead.

## Typography table

| Element | Size | Weight |
|---|---|---|
| Body | 10.5pt | Regular |
| H1 (centered) | 24pt | Bold |
| H2 | 16pt | Bold |
| H3 | 13pt | Bold |
| H4 | 11pt | Bold |
| Inline code | 9.6pt | Regular |
| Code block | 9.3pt | Regular |
| Blockquote | 10pt | Regular |
| Footer page number | 8pt | Regular |

## Design reference

See `DESIGN.md` in this directory for the full palette and typography spec this theme draws from.
