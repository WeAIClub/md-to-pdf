# md-to-pdf 样例文档

这是一份用来展示 `md-to-pdf` 渲染效果的示例文档。它覆盖了 Markdown 常用的所有元素，既有中文正文，也有英文段落，还有代码、表格、引用和列表，方便你在看效果的时候一眼对齐每种元素最终长什么样。

This is a bilingual sample. Scroll through and you will see headings, emphasis, inline code, code blocks, quotes, tables, horizontal rules, and both ordered and unordered lists rendered in a consistent serif aesthetic.

## 一、标题层级

### 三级标题：字号递减、颜色变暖

#### 四级标题：最小的常用层级

正文从这里继续。用衬线字体排中文长段落会比较有"书卷气"，比较适合把长报告、研究笔记、读书笔记这些内容转成 PDF 存档。段落之间保留合适的行距，让阅读节奏自然。

## 二、行内强调

纯正文。*斜体用来引入术语*，**粗体用来强调关键词**，也可以把 `inline code` 和文件名（如 `config.toml`、`~/.claude/settings.json`）做成行内代码高亮。链接长这样：[Typst 官网](https://typst.app) 和 [Pandoc 官网](https://pandoc.org)。

In English paragraphs, the same rules apply: *italics* for terms, **bold** for emphasis, `inline code` for identifiers like `fetch()` or `typst compile`, and [external links](https://github.com) rendered in terracotta with an underline.

## 三、列表

Markdown 无序列表用短横线 `-`、星号 `*` 或加号 `+` 开头，每个条目独占一行。渲染后会出现圆点项目符号，嵌套一层自动变成三角标识，再往下还会继续区分层级。下面是一份带二级嵌套的例子，展示条目怎样自然地缩进：

- 一级条目 A
- 一级条目 B
  - 二级条目 B.1
  - 二级条目 B.2
- 一级条目 C

有序列表用阿拉伯数字加英文句点开头，数字可以自增，也可以全部写成 `1.` —— Pandoc 会在编译时重新生成序号，写错也不会乱。一般建议写成自然递增，方便在纯文本里阅读。下面是一份三步走的示例：

1. 第一步：写 Markdown
2. 第二步：跑 `./scripts/md_to_pdf.sh input.md output.pdf`
3. 第三步：打开生成的 PDF 看效果

## 四、代码块

代码块需要在前后各写三个反引号，第一行反引号后紧跟语言标签即可启用语法高亮。shell / bash 脚本通常会高亮关键字、字符串和控制流，方便快速定位脚本中的主干结构。下面是一段批量把当前目录下所有 Markdown 转成 PDF 的脚本：

```bash
#!/usr/bin/env bash
set -euo pipefail

for f in *.md; do
  ./scripts/md_to_pdf.sh "$f" "${f%.md}.pdf"
done
```

Python 代码同样支持语法高亮，关键字、字符串字面量、内置函数和装饰器都会获得不同颜色。Typst 内置的代码高亮器基于 Tree-sitter，覆盖了当前主流的技术栈，对绝大多数写技术文档的场景都够用。例如下面这段简单的文件读取函数：

```python
def render_markdown(path: str) -> str:
    """Read a markdown file and return its content."""
    with open(path, encoding="utf-8") as fh:
        return fh.read()
```

## 五、引用

> 好的排版不是让文字更漂亮，而是让读者不再注意到字体本身，把注意力完全留给内容。
>
> — 某位排版爱好者

## 六、表格

| 功能 | 是否支持 | 说明 |
|---|---|---|
| 中文衬线正文 | ✅ | 使用打包字体，不依赖系统 |
| 行内代码高亮 | ✅ | 赤陶色 + 淡桃底 |
| 代码块 | ✅ | 象牙底 + 圆角 |
| 引用块 | ✅ | 暖沙底 + 赤陶左竖线 |
| 表格 | ✅ | 1fr 均分列宽，header 下赤陶粗线 |
| 自动生成目录 | ❌ | 需要自己在 Markdown 里写 |

## 七、分隔线

Markdown 里用三个或以上的连续短横线 `---` 可以插入一条水平分隔线，它通常用来做无标题的章节过渡、分隔相对独立的内容块，或者在读书笔记里区分不同出处的引用。下面就是一条典型的分隔线：

---

分隔线之后，正文可以继续流淌。分隔线本身不占章节序号，所以 PDF 目录里不会出现它；但它能在阅读节奏上提供一个明确的视觉停顿，适合用来提醒读者"这里要换一个话题了"。这种轻量级的视觉锚点在长文里尤其有用。

## 八、结语

这份样例到这里就结束了。如果你看到的 PDF 里：

- 标题 H1 居中、H2 左边有赤陶色竖条
- 行内代码是淡桃底 + 赤陶字
- 表格 header 底下有一条赤陶色粗线
- 中文字体是衬线，不是黑体 / 无衬线

说明渲染管道工作正常。接下来你可以把自己的 Markdown 丢进来试试。
