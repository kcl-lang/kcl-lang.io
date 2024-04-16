---
slug: 2024-02-22-newsletter
title: KCL Newsletter (2024.02.02 - 2024.02.22)
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter.png)

[KCL](https://github.com/kcl-lang) is a constraint-based record and functional language hosted by Cloud Native Computing Foundation (CNCF) that enhances the writing of complex configurations and polices, including those for cloud-native scenarios. With its advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

This section will update the KCL language community's latest news, including features, website updates, and the latest community news, helping everyone better understand the KCL community!

**_KCL Website: [https://kcl-lang.io](https://kcl-lang.io)_**

## Overview

Thanks to to all contributors for their outstanding work over the past twenty days (2024.02.02 - 2024.02.22). Here is an overview of the key content:

**📦 Module Updates**

The JSON Schema module 0.0.4 has released, fixing type definition errors. You can update or add dependencies by running the following command:

```shell
kcl mod add jsonschema:0.0.4
```

**🏄 Language Updates**

KCL has released preview version 0.8.0, mainly including the following updates:

- Added the file system library for reading KCL module information and system files, including the `read`, `glob`, `workdir`, and `modpath` functions. See more details in this [issue](https://github.com/kcl-lang/kcl/issues/1049)
- Optimized syntax error messages for unexpected tokens.
- Removed output for unexpected internal built-in type attributes in schema objects.
- Fixed variable calculation in unexpected dictionary generation expressions where the key is the same as the loop variable.
- Fixed errors in defining string identifiers within schemas, such as `"$if"`.

**🔧 Toolchain Updates**

- `kcl run` supports using the -H parameter to output hidden fields starting with `_`.
- `kcl run` supports running remote Git repository code directly.
- Introduce the `kcl mod graph` subcommand used to output module dependency graphs.
- Fixed formatting errors when there is an if statement within an else block.

**💻 IDE Updates**

- Enhanced autocompletion and hover documentation for built-in functions and system libraries
- Fixed issues with navigating and autocompleting if statements symbols within configuration blocks
- Added quick fix feature for variable reference errors

**🎁 API Updates**

- The `OverrideFile` API has added path for querying and modifying configurations, such as `a["b"].c`
- The `Run` API has added the `WithShowHidden` and the `WithTypePath` flags.

**🚀 Plugin System Updates**

In addition to using Python for KCL plugin functions, it now supports using Go to write plugin functions for KCL, which is very simple to use.

- Define a plugin (using a hello plugin containing the add function as an example)

```go
package hello_plugin

import (
	"kcl-lang.io/kcl-go/pkg/plugin"
)

func init() {
	plugin.RegisterPlugin(plugin.Plugin{
		Name: "hello",
		MethodMap: map[string]plugin.MethodSpec{
			"add": {
				Body: func(args *plugin.MethodArgs) (*plugin.MethodResult, error) {
					v := args.IntArg(0) + args.IntArg(1)
					return &plugin.MethodResult{V: v}, nil
				},
			},
		},
	})
}
```

- Use the plugin

```go
package main

import (
	"fmt"

	"kcl-lang.io/kcl-go/pkg/kcl"
	"kcl-lang.io/kcl-go/pkg/native"                // Import the native API
	_ "kcl-lang.io/kcl-go/pkg/plugin/hello_plugin" // Import the hello plugin
)

func main() {
	// Note we use `native.MustRun` here instead of `kcl.MustRun`, because it needs the cgo feature.
	yaml := native.MustRun("main.k", kcl.WithCode(code)).GetRawYamlResult()
	fmt.Println(yaml)
}

const code = `
import kcl_plugin.hello

name = "kcl"
three = hello.add(1,2) # 3
`
```

**🚢 Integration Updates**

- Released initial version of Ansible KCL module, supporting basic execution of KCL code, with other functionalities being improved
- Optimized Git Source functionality for KCL FluxCD Controller, with OCI Source functionality in progress

## Special Thanks

The following are listed in no particular order:

- Thanks to @octonawish-akcodes and @d4v1d03 for their continuous contributions to KCL FAQ documentation and KCL IDE functionality 🙌
- Thanks to @octonawish-akcodes for the contribution to the Ansible KCL Module
- Thanks to @AkashKumar7902 and @Vanshikav123 for the contribution to the KCL package management tool functionality 🙌
- Thanks to @StevenLeiZhang for the contribution to KCL documentation and KCL plugins
- Thanks to @TheChinBot, @Evgeny Shepelyuk, @yonas, @steeling, @vtomilov, @Fdall, @CloudZero357, @bozaro, @starkers, @MrGuoRanDuo and @FLAGLORD, among others, for their valuable feedback and suggestions while using KCL recently. 🙌

## Resources

❤️ Thanks to all KCL users and community members for their valuable feedback and suggestions in the community. See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
- [KCL v0.8.0 Milestone](https://github.com/kcl-lang/kcl/milestone/8)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
