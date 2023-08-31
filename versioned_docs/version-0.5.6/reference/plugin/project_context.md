# project_context

project_context extract base info from project.yaml&stack.yaml

*version: 0.0.1*

## `get_project_current_path`

return the relative path of first file

Example:

```py
import kcl_plugin.project_context as ctx

path = ctx.get_project_current_path()
print(path)
```

## `get_project_input_file`

return compiling file list

Example:

```py
import kcl_plugin.project_context as ctx

input_file = ctx.get_project_input_file()
print(input_file)
```

## `get_project_context`

return the current project context from project.yaml

Example:

```py
import kcl_plugin.project_context as ctx

project = ctx.get_project_context()
# Get project name
print(project?.name)
```

## `get_stack_context`

return the current stack context from stack.yaml

Example:

```py
import kcl_plugin.project_context as ctx

stack = ctx.get_stack_context()
# Get stack name
print(stack?.name)
```
