// terracotta-white-bold theme
// Same as terracotta-white, but `**bold**` uses stroke-based synthetic bold
// for stronger emphasis on fonts without a native 700 weight.

// ── Color tokens ──
#let pure-white   = rgb("#ffffff")
#let ivory        = rgb("#faf9f5")
#let warm-sand    = rgb("#e8e6dc")
#let near-black   = rgb("#141413")
#let olive-gray   = rgb("#5e5d59")
#let stone-gray   = rgb("#87867f")
#let charcoal     = rgb("#4d4c48")
#let dark-warm    = rgb("#3d3d3a")
#let terracotta   = rgb("#c96442")
#let coral        = rgb("#d97757")
#let border-cream = rgb("#f0eee6")
#let border-warm  = rgb("#e8e6dc")
#let peach-hl     = rgb("#fbe3d3")  // 行内代码 / 文件名高亮

// ── 页面 ──
#set page(
  paper: "a4",
  margin: (top: 26mm, bottom: 20mm, left: 22mm, right: 22mm),
  fill: pure-white,
  footer: context [
    #set align(center)
    #set text(size: 8pt, fill: stone-gray, font: "LXGW Bright GB")
    — #counter(page).display() —
  ],
)

// ── 全局字体与段落 ──
#set text(
  font: ("LXGW Bright GB", "PT Serif", "Times"),
  size: 10.5pt,
  fill: near-black,
  lang: "zh",
)
#set par(leading: 0.85em, justify: true, first-line-indent: (amount: 2em, all: true))
#show emph: set text(style: "italic")
#show strong: set text(weight: "regular", fill: near-black, stroke: 0.2pt + near-black)

// ── 链接 ──
#show link: it => {
  set text(fill: terracotta)
  underline(offset: 2pt, stroke: 0.3pt + terracotta, it)
}

// ── 标题 ──
#show heading: set par(first-line-indent: 0em)
#show heading.where(level: 1): it => block(width: 100%)[
  #set align(center)
  #set text(size: 24pt, weight: "bold", fill: near-black, font: "LXGW Bright GB")
  #v(2mm)
  #it.body
  #v(3mm)
]
#show heading.where(level: 2): it => block[
  #v(7mm)
  #set text(size: 16pt, weight: "bold", fill: near-black, font: "LXGW Bright GB")
  #block(
    inset: (left: 4mm, top: 1mm, bottom: 1mm),
    stroke: (left: 3pt + terracotta),
    it.body,
  )
  #v(3mm)
]
#show heading.where(level: 3): it => block[
  #v(4mm)
  #set text(size: 13pt, weight: "bold", fill: dark-warm, font: "LXGW Bright GB")
  #it.body
  #v(2mm)
]
#show heading.where(level: 4): it => block[
  #v(3mm)
  #set text(size: 12pt, weight: "bold", fill: near-black, font: "LXGW Bright GB")
  #it.body
  #v(1.5mm)
]

// ── 行内代码 / 文件名高亮（淡桃底 + terracotta 字） ──
#show raw.where(block: false): it => box(
  fill: peach-hl,
  inset: (x: 3pt, y: 1pt),
  outset: (y: 1pt),
  radius: 3pt,
  text(font: "LXGW Bright Code GB", fill: terracotta, size: 9.6pt, it.text),
)

// ── 代码块 ──
#show raw.where(block: true): it => block(
  fill: ivory,
  stroke: 0.6pt + border-warm,
  radius: 8pt,
  inset: (x: 5mm, y: 4mm),
  width: 100%,
  text(font: "LXGW Bright Code GB", fill: near-black, size: 9.3pt, it),
)

// ── 引用 ──
#show quote.where(block: true): it => block(
  fill: warm-sand,
  stroke: (left: 3pt + terracotta),
  radius: (right: 6pt),
  inset: (x: 6mm, y: 4mm),
  width: 100%,
  {
    set par(first-line-indent: 0em)
    text(fill: charcoal, size: 10pt, it.body)
  },
)

// ── 表格（方案 B）──
// 所有行列 0.4pt 淡灰线 + pandoc 在 header 后插的 table.hline() 变 1.2pt terracotta
#set table(
  stroke: 0.4pt + border-warm,
  inset: 3mm,
)
#set table.hline(stroke: 1.2pt + terracotta)

// pandoc figure.where(kind: table) 默认会 align(center) 裹 table，
// 我们用 show 去掉那层，避免 table 居中不撑满
#show figure.where(kind: table): it => block(width: 100%, it.body)

// ── 分隔线（pandoc 输出 #horizontalrule，Typst 无此内置，需自行定义） ──
#let horizontalrule = block(
  above: 4mm,
  below: 4mm,
  line(length: 100%, stroke: 0.5pt + border-warm),
)
