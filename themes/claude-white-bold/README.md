# claude-white-bold

Variant of `claude-white` with stronger bold emphasis. **The only difference is how `**bold**` is rendered**:

- `claude-white`: `weight: "bold"` — with the bundled serif (no native 700), the renderer falls back to synthesized bold, which reads fairly soft.
- `claude-white-bold`: `weight: "regular"` + `stroke: 0.2pt + near-black` — a stroke-based synthetic bold (similar to how browsers render synthetic bold), giving a noticeably stronger contrast.

Everything else — fonts, colors, headings, tables, code blocks, quotes — is identical.

## Characteristics

- **Background**: Pure White `#ffffff`
- **Typography**: Serif body and headings, monospace for code (uses bundled fonts from `fonts/`)
- **Primary accent**: Terracotta `#c96442`
- **Headings**: H1 centered 24pt bold; H2 16pt bold with terracotta left bar; H3 13pt bold; H4 11pt bold
- **Tables**: 0.4pt warm-gray cell borders, 1.2pt terracotta header underline, `1fr` equal-width columns
- **Inline code**: peach background + terracotta text

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
