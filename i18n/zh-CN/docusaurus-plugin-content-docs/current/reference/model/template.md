---
title: "template"
linkTitle: "template"
type: "docs"
description: 模版操作
weight: 100
---

## execute

`execute(template: str, data: {str:any} = {}) -> str`

将解析过的模板应用于指定的数据对象，并返回字符串输出。查看 https://handlebarsjs.com/ 获取更多文档和示例。

```python3
import template

content = template.execute("""\
<div class="entry">
{{#if author}}
<h1>{{firstName}} {{lastName}}</h1>
{{/if}}
</div>
""", {
  author: True,
  firstName: "Yehuda",
  lastName: "Katz",
})
```

## html_escape

`html_escape(data: str) -> str`

将字符 `&"<>` 替换为等效的 html / xml实体。

```python3

import template

content = template.html_escape("""\
<div class="entry">
{{#if author}}
<h1>{{firstName}} {{lastName}}</h1>
{{/if}}
</div>
""")
```
