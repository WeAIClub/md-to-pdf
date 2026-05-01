# md-to-pdf 示例

> 好的排版不是让文字更漂亮，而是让读者忘记字体本身的存在，把注意力完全留给内容。

This sample showcases how **md-to-pdf** typesets a Markdown source via the `pandoc → Typst` pipeline, under the claude-white theme.

## 一、代码块

pandoc → Typst 管道会把 fenced code block 转成带语法高亮的排版。主题给代码块配了象牙色底、暖灰色描边和圆角；关键字、字符串、数字、注释分别染色，字号和行距相对正文略小以突出其「引用」属性。

```python
def render(path: str, theme: str = "claude-white") -> bytes:
    """Render a Markdown file into a PDF byte string."""
    with open(path, encoding="utf-8") as fh:
        return typeset(fh.read(), theme=theme, dpi=300)
```

## 二、列表

纯正文。*斜体用来引入术语*，**粗体用来强调关键词**，也可以把 `inline code` 和文件名（如 `config.toml`、`~/.claude/settings.json`）做成行内代码高亮。链接长这样：[Typst 官网](https://typst.app) 和 [Pandoc 官网](https://pandoc.org)。

In English paragraphs, the same rules apply: *italics* for terms, **bold** for emphasis, `inline code` for identifiers like `fetch()` or `typst compile`, and [external links](https://github.com) rendered in terracotta with an underline.

1. 写好 Markdown
2. 跑脚本 `./scripts/md_to_pdf.sh input.md output.pdf`
3. 打开生成的 PDF

## 三、表格

表格的每个单元格用 0.4pt 暖灰色细线框出，表头下方单独加一条 1.2pt 赤陶色粗线做强分隔。列宽走 Typst 的 `1fr` 等分撑满页宽，不管列数多少都能铺满。

| 元素 | 效果 | 说明 |
|---|---|---|
| 代码块 | 象牙底 + 圆角 | 语法高亮走 Typst 内置 |
| 列表 | 圆点 / 数字 + 层级缩进 | 嵌套自动换标识 |
| 表格 | 细线框 + 粗线表头 | 1fr 等分列宽 |
