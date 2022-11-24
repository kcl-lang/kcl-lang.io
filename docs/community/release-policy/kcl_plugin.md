# KCL Plugin Release Policy

KCL 插件的设计初衷只是为了扩展 KCL 语言的功能，其定位并不是完全复刻通用的编程语言全部生态。因此 KCL 插件刻意做了一些必要的限制：首先插件之间不能相互导入；其次在同一个模块中插件不能同名；最后Python实现的插件指南使用标准库和插件框架提供的功能。

## 1. 每个插件独立维护版本

基于以上的设计背景，同一个 kcl.mod 定义的模块中每个插件是相互独立的，插件之间和其依赖均不会出现依赖冲突的问题。因此，每个 KCL 插件可以独立发布独立维护。

## 2. kcl.mod 指定依赖的插件信息

kcl.mod 中 `[kcl_plugin]` 字段标注插件信息：

```toml
# kcl.mod

[kcl_plugin]
hello = { git = "https://github.com/KusionStack/kcl-plugin.git", path = "hello", branch = "master" }
project_context = { git = "https://github.com/KusionStack/kcl-plugin.git", path = "project_context", version = "0.1.0"}
utils = { path = "${PATH}/plugins/utils" }
```

## 3. 插件对 KCLVM 的版本依赖

插件本身可以指定依赖的 KCL 语言的版本，相关工具做检查。

