---
title: "template"
linkTitle: "template"
type: "docs"
description: template functions
weight: 100
---

## execute

`execute(template: str, data: {str:any} = {}) -> str`

Applies a parsed template to the specified data object and returns the string output. See https://handlebarsjs.com/ for more documents and examples.

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

Replaces the characters `&"<>` with the equivalent html / xml entities.

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
