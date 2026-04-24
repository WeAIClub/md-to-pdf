# md-to-pdf

[English](./README.md) · **中文**

> 把 Markdown 转成排版精美的 PDF。衬线字体、赤陶色点缀、暖白页面。

一条 `pandoc → Typst` 管道，配两套预设主题和打包好的字体 —— 不需要往系统里装字体。

点 [`examples/sample.pdf`](./examples/sample.pdf) 看成品效果。

## 特性

- ✨ **两套预设主题**：`terracotta-white`（推荐）和 `terracotta-white-bold` —— 暖白底、赤陶点缀、衬线字体
- 📦 **字体随仓库打包**：通过 `typst --font-path` 加载，不需要你安装到系统字体目录
- 🤖 **开箱即用的 Claude Code skill**（见下），同时作为纯 CLI 工具可被其他 AI 代理（Gemini CLI、Codex CLI、Qoder、Cursor 等）或直接被人调用
- 🧩 **易于扩展主题**：每个主题就一个 `theme.typ` 文件，写一个扔进去、作为第三个参数传就行

## 安装依赖

你需要把 **pandoc ≥ 3.2**（Typst writer 是 pandoc 3.2 才加的）和 **typst** 放到 `PATH` 里。

**macOS（Homebrew）：**
```bash
brew install pandoc typst
```

**Linux（Debian/Ubuntu）：**
```bash
sudo apt install pandoc
# typst 从官方预编译二进制装：
# https://github.com/typst/typst/releases
```

**Linux（Arch）：**
```bash
sudo pacman -S pandoc typst
```

> **Windows** 暂不官方支持（脚本是 bash）。Git Bash 或 WSL 理论上能跑，但未测试。

## 快速开始

```bash
git clone https://github.com/WeAIClub/md-to-pdf
cd md-to-pdf
./scripts/md_to_pdf.sh examples/sample.md out.pdf
open out.pdf      # macOS；Linux 用 xdg-open
```

## 用法

```bash
./scripts/md_to_pdf.sh <input.md> <output.pdf> [theme]
```

| 参数 | 说明 |
|---|---|
| `input.md` | Markdown 源文件路径（绝对或相对） |
| `output.pdf` | 输出 PDF 路径 |
| `theme` | 主题名，可选。默认 `terracotta-white`。 |

成功时打印 `[OK] /绝对/路径.pdf`。

## 主题

| 主题 | 说明 |
|---|---|
| `terracotta-white` | **推荐**。默认 bold 字重。对没有原生 700 字重的字体，系统合成粗体较柔和。 |
| `terracotta-white-bold` | 同款设计，但 `**bold**` 改用描边合成粗体，对比更强。 |

每个主题目录下的 `README.md` 有完整字号表。

## 作为 Claude Code skill 使用

把仓库 clone 到 Claude Code 的 skills 目录，Claude 会自动发现：

```bash
git clone https://github.com/WeAIClub/md-to-pdf ~/.claude/skills/md-to-pdf
```

然后对 Claude 说「把 handoff.md 转成 PDF」，它会自动调用这个 skill。

## 配合其他 AI CLI 使用（Gemini CLI / Codex CLI / Qoder / Cursor…）

看 [`AGENTS.md`](./AGENTS.md) —— 一份短的、面向 AI 代理的使用说明。任何能读仓库的 AI 代理都能照着用。

## 加你自己的主题

1. 新建 `themes/<你的主题>/theme.typ`
2. 写齐必需的 `#set` 和 `#show` 规则（参考 `themes/terracotta-white/theme.typ`：需要 color tokens、页面设置、文本/段落默认、各级标题、strong/emph/link、行内/块级 raw、quote、table，以及一个 `#let horizontalrule = ...` 定义）
3. 跑：`./scripts/md_to_pdf.sh input.md output.pdf <你的主题>`

完整的 `theme.typ` hook 清单见 [`SKILL.md`](./SKILL.md)。

## 架构

```
md-to-pdf/
├── SKILL.md                     # Claude Code skill 入口
├── AGENTS.md                    # 其他 AI 代理用的说明
├── README.md / README.zh.md     # 给人看的文档
├── LICENSE                      # MIT（项目代码）
├── scripts/md_to_pdf.sh         # 主管道脚本
├── themes/                      # 每个主题一个目录
│   ├── terracotta-white/
│   └── terracotta-white-bold/
├── fonts/                       # 打包字体 + OFL license
└── examples/
    ├── sample.md
    └── sample.pdf
```

管道：
1. `pandoc input.md --to typst` → Typst body fragment
2. 后处理 `columns: N` → `columns: (1fr,)*N`，让表格撑满页宽
3. 把 `theme.typ + body.typ` 拼成单个 Typst 文件
4. `typst compile --font-path fonts/`

## 致谢

- **字体** —— [LXGW Bright GB](https://github.com/lxgw/LxgwBright) 和 [LXGW Bright Code GB](https://github.com/lxgw/LxgwBright-Code)，作者陈亿堃（LXGW），采用 SIL Open Font License 1.1 授权。完整版权声明见 [`fonts/LICENSE-LXGW.txt`](./fonts/LICENSE-LXGW.txt)。
- **设计参考** —— 每个主题目录下有 `DESIGN.md`，标注了调色板和字体设定的来源。
- **底层管道** —— [pandoc](https://pandoc.org) 和 [typst](https://typst.app) 负责所有重活。

## 许可证

项目代码和主题：[MIT](./LICENSE)。

打包字体：[OFL 1.1](./fonts/LICENSE-LXGW.txt)。
