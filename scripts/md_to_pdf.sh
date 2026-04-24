#!/usr/bin/env bash
# md-to-pdf: Markdown -> beautifully typeset PDF (pandoc → typst pipeline)
# Usage: md_to_pdf.sh <input.md> <output.pdf> [theme=terracotta-white]

set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 <input.md> <output.pdf> [theme]

Arguments:
  input.md    Markdown input file
  output.pdf  PDF output path
  theme       Theme name; defaults to 'terracotta-white'.
              Available: 'terracotta-white' (recommended), 'terracotta-white-bold'.

Dependencies:
  - pandoc (on PATH)   https://pandoc.org/installing.html
  - typst  (on PATH)   https://github.com/typst/typst#installation

Fonts are bundled under fonts/ and loaded via --font-path;
no system font installation required.
EOF
  exit 1
}

[ $# -ge 2 ] || usage

INPUT="$1"
OUTPUT="$2"
THEME="${3:-terracotta-white}"

[ -f "$INPUT" ] || { echo "Input file not found: $INPUT" >&2; exit 1; }

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEME_DIR="$SKILL_DIR/themes/$THEME"
THEME_TYP="$THEME_DIR/theme.typ"
FONTS_DIR="$SKILL_DIR/fonts"

[ -f "$THEME_TYP" ] || { echo "Theme not found: $THEME ($THEME_TYP)" >&2; exit 1; }

PANDOC="${PANDOC:-pandoc}"
TYPST="${TYPST:-typst}"

command -v "$PANDOC" >/dev/null 2>&1 || {
  echo "pandoc not found on PATH. Install it: https://pandoc.org/installing.html" >&2
  exit 1
}
command -v "$TYPST"  >/dev/null 2>&1 || {
  echo "typst not found on PATH. Install it: https://github.com/typst/typst#installation" >&2
  exit 1
}

WORK_DIR="$(mktemp -d -t md-to-pdf.XXXXXX)"
trap 'rm -rf "$WORK_DIR"' EXIT

# 1. Copy theme into work directory
cp "$THEME_TYP" "$WORK_DIR/theme.typ"

# 2. pandoc: Markdown -> Typst body fragment
#    --from markdown-citations disables the citation extension so handles like
#    @Google / @_davideast don't trigger "document does not contain a bibliography".
"$PANDOC" "$INPUT" --from markdown-citations --to typst -o "$WORK_DIR/body.typ"

# 3. Fix pandoc output: `columns: N,` -> `columns: (1fr,)*N,` so tables span the page width
perl -i -pe 's/columns: (\d+),/"columns: (1fr,)*$1,"/ge' "$WORK_DIR/body.typ"

# 4. Concatenate theme + body into a single scope.
#    `#include` isolates scope, which would strip the body's access to theme-level
#    `#let` definitions like `horizontalrule`; plain cat keeps everything visible.
cat "$WORK_DIR/theme.typ" "$WORK_DIR/body.typ" > "$WORK_DIR/run.typ"

# 5. typst compile — with bundled fonts
OUTPUT_DIR="$(cd "$(dirname "$OUTPUT")" && pwd)"
OUTPUT_ABS="$OUTPUT_DIR/$(basename "$OUTPUT")"

if [ -d "$FONTS_DIR" ]; then
  "$TYPST" compile --font-path "$FONTS_DIR" "$WORK_DIR/run.typ" "$OUTPUT_ABS"
else
  "$TYPST" compile "$WORK_DIR/run.typ" "$OUTPUT_ABS"
fi

echo "[OK] $OUTPUT_ABS"
