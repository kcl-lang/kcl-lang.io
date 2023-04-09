---
sidebar_position: 0
---

# Overview

KCL provides engineering extensibility through built-in modules, system modules and plug-in modules.

![](/img/docs/reference/lang/model/kcl-module.png)

The user code does not need to import functions that directly use builtin functions (such as calculating the length of a list with `len`, obtaining the type of value through `typeof`, etc.), and for basic types such as strings, it also provides some built-in methods (such as converting the case of strings, etc.).

For relatively complex general logic, it is provided through the system modules. For example, by importing the `math` module, we can use related mathematical functions, and we can use the regular expression by importing the `regex` module. For KCL code, it can also be organized into different user modules.

In addition, Python and Go can be used to develop plug-ins for KCL through the plugin mechanism. For example, there are the app-context plug-in can be used to obtain the context information of the current application to simplify code writing.
