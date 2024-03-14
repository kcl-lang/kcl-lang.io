---
slug: 2023-new-version-feature-interpretation-kclvm-go-feature-overview
title: See Goodbye to Old KCL Go SDK, the New One is Out!
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, kclvm-go]
---

## What is KCL

[KCL](https://github.com/kcl-lang/kcl) is an open-source, constraint-based record and functional language. KCL improves the writing of numerous complex configurations, such as cloud-native scenarios, through its mature programming language technology and practice. It is dedicated to building better modularity, scalability, and stability around configurations, simpler logic writing, faster automation, and great built-in or API-driven integrations.

## What is KCL Go SDK?

kclvm is a runtime library for the KCL language that provides a programming interface for interacting with the KCL compiler. It is a client library that can be used to perform various operations on KCL source code such as execution and formatting. KCL Go SDK is a Go language wrapper for kclvm that provides an SDK for KCL language integration in cloud-native environments.

The current version of `KCL Go SDK` is built on top of the kclvm json2 RPC API, which means that it uses the same API as other language KCL clients to interact with KCL source code. The way it works is similar to other language KCL SDKs, but it provides a more user-friendly Go language style wrapper.

## What problems does the new version of KCL Go SDK solve?

KCL is closely related to the cloud-native domain as a configuration language, while on the other hand, Go has become the de facto standard programming language for cloud-native domains. In this context, the development of a Go SDK for the KCL compiler to directly interact with Go was necessary, which is the reason for the creation of `KCL Go SDK`.

The initial version of the KCL compiler and runtime were written in Python, and the runtime for the first version of the KCL language had a lot of room for improvement in terms of performance and security due to the performance issues and characteristics of the dynamic nature of the Python language. In light of security and efficiency considerations, later versions of the KCL compiler were written in the Rust programming language. As a result, the new version of `KCL Go SDK` is based on rust-implemented kclvm packaging, eliminating Python dependencies, simplifying installation, and optimizing the user experience.

## How to integrate KCL with Go code?

Here is an example of how to integrate KCL into your Go program. Using the hello.k file from the previous example, construct the following main.go code:

```go
package main

import (
	"fmt"

	kcl "kcl-lang.io/kcl-go"
)

func main() {
	yaml := kcl.MustRun("kubernetes.k", kcl.WithCode(code)).GetRawYamlResult()
	fmt.Println(yaml)
}

const code = `
apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "nginx"
    labels.app = "nginx"
}
spec = {
    replicas = 3
    selector.matchLabels = metadata.labels
    template.metadata.labels = metadata.labels
    template.spec.containers = [
        {
            name = metadata.name
            image = "${metadata.name}:1.14.2"
            ports = [{ containerPort = 80 }]
        }
    ]
}
`
```

- `kcl.MustRun("kubernetes.k", kcl.WithCode(code)).GetRawYamlResult()` runs the corresponding KCL source file
- `fmt.Println(yaml)` prints the result of the run

## Conclusion

Through the version change, we have removed Python dependencies and switched to a more efficient Rust runtime. The article briefly demonstrates how to use the kcl-go command line tool to execute KCL source code and how to integrate KCL into your Go program.

In addition to compiling and running KCL source code, the KCL Go SDK provides a variety of features to facilitate KCL integration in Go, including:

- KCL static error analysis (lint and format)
- KCL dependency analysis
- Go struct and KCL Schema mutual conversion

## Additional Resources

Thank all KCL users for their valuable feedback and suggestions during this version release. For more resources, please refer to:

- [KCL Website](https://kcl-lang.io/)
- [Kusion Website](https://kusionstack.io/)
- [KCL Repo](https://github.com/kcl-lang/kcl)
- [kcl-go Repo](https://github.com/kcl-lang/kcl-go)
- [Kusion Repo](https://github.com/KusionStack/kusion)
- [Konfig Repo](https://github.com/KusionStack/konfig)

See the [community](https://github.com/kcl-lang/community) for ways to join us. 👏👏👏
