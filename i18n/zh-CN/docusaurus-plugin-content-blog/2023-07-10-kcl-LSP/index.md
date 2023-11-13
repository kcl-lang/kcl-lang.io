# 用 Rust 重写的 KCL LSP

KCL 的 v0.4.6 版本在语言、工具链、社区集成&扩展支持等方面进行了重点更新。本文将为您详细介绍IDE的新功能、LSP的介绍、KCL LSP Server端的设计和实现以及未来的规划和期望。

## IDE的新特性

在这次更新中，我们发布了全新 KCL VSCode 插件，并且用 Rust 重写了 LSP 的 Server 端。我们提供了 IDE 中常用的代码辅助功能，如高亮、跳转、补全、Outline、悬停、错误提示等。

- **高亮:**
  ![Highlight](/img/docs/tools/Ide/vs-code/Highlight.png)
- **跳转:**
  ![Goto Definition](/img/docs/tools/Ide/vs-code/GotoDef.gif)
- **补全:**
  ![Completion](/img/docs/tools/Ide/vs-code/Completion.gif)
- **Outline:**
  ![Outline](/img/docs/tools/Ide/vs-code/Outline.gif)
- **Hover:**
  ![Hover](/img/docs/tools/Ide/vs-code/Hover.gif)
- **Diagnostics:**
  ![Diagnostics](/img/docs/tools/Ide/vs-code/Diagnostics.gif)

欢迎到 [KCL VSCode 插件](https://kcl-lang.io/docs/tools/Ide/vs-code/) 了解更多👏🏻👏🏻👏🏻

## 什么是 LSP？

在这次更新中，我们基于 LSP 实现了以上能力。LSP 指的是 Language Server Protocol，它是由微软在 2016 年推出的一种用于编程语言工具的协议。借用一张图，很容易就可以理解 LSP。

![LSP](/img/blog/2023-07-10-kcl-LSP/lsp.png)

通过 LSP ，编辑器和 IDE 可以通过 JSON-RPC 通信协议与后端运行的语言服务器(Server 端)进行通信。语言服务器可以提供代码分析、自动补全、语法高亮、定义跳转等功能。基于 LSP，开发者可以在不同的编辑器和 IDE 之间迁移，使得语言工具的开发从 M(语言数量) \* N(编辑器/IDE数量) 降低为 M + N。

## 为什么用 Rust 重写

KCL 编译器和其他工具最初由 Python 实现，因为性能原因，我们用 Rust 语言重写了编译器。在此之后，我们使用 Rust 逐步重写了 KCL 的其他工具，如测试工具、Format 工具等。在这次更新中，我们用 Rust 重写了 LSP Server 端，其主要考虑因素也是性能。

过去，Python 版本的 Server 端在处理一些复杂的场景（编译文件数量超过200个）时，处理一个跳转的请求，Server 端从接收到请求到计算结果并响应，时间长达 6 秒以上，几乎是不可用状态。由于 Server 端的实现主要基于语言编译器前中端的词法解析和语义分析，在我们使用 Rust 重写以后，这部分性能分别提升了 20 和 40 倍， 带来的显著结果就是 Server 端的响应时间得到了巨大提升，对于同样的场景，响应时间缩短至 100 毫秒左右。而对于一些简单的场景，响应时间只有几毫秒，做到了用户无感。

## KCL LSP Server的设计与实现

KCL LSP Server 的设计如下图所示：

![KCL-LSP](/img/blog/2023-07-10-kcl-LSP/kcl-LSP.png)

主要流程可以分为几个阶段：

1. 建立连接，初始化 LSP 能力。在 IDE 的 Client 端，打开特定文件（KCL的 \*.k）时，IDE 会启动本地的 kcl_language_server 二进制文件，启动 Server 端。这个文件与 KCL 一起发布，并安装在 KCL 的 bin 目录下。Server 启动后会建立 standard IO 的 Connection，并等待 Client 发送的初始化请求。Server 端接收初始化请求后会定义 Server 端信息和能力，并返回给 Client，以此完成 LSP 的初始化连接。
2. 建立连接后，Server 端会启动一个轮询函数，不断接收来自 Client 的 LSP Message，例如 Notification（打开/关闭/变更/删除文件等）和 Request（跳转、悬停等），以及来自 Server 端自身的 Task。并统一封装成事件（Event）交给下一步处理。
3. 对于各种事件，按照以下步骤处理：

```Rust
/// Handles an event from one of the many sources that the language server subscribes to.
fn handle_event(&mut self, event: Event) -> anyhow::Result<()> {
    // 1. Process the incoming event
    match event {
        Event::Task(task) => self.handle_task(task)?,
        Event::Lsp(msg) => match msg {
            lsp_server::Message::Request(req) => self.on_request(req, start_time)?,
            lsp_server::Message::Notification(not) => self.on_notification(not)?,
            _ => {}
        },
    };

    // 2. Process changes
    let state_changed: bool = self.process_vfs_changes();

    // 3. Handle Diagnostics
    if state_changed{
        let mut snapshot = self.snapshot();
        let task_sender = self.task_sender.clone();
        // Spawn the diagnostics in the threadpool
        self.thread_pool.execute(move || {
            handle_diagnostics(snapshot, task_sender)？;
        });
    }

    Ok(())
}
```

3.1 任务分发：根据任务类型，做函数分发。在子函数中，会进一步基于 Request 或 Notification 的类型继续分发到最终的处理函数中，如处理文件变更、处理跳转请求等。这些函数会根据基于编译器中前端编译出的语义模型（AST，符号表，错误信息等）做分析，计算生成对应的 Response（如跳转请求的目标位置）。

3.2 处理变更：用户在修改代码或更改文件时，会发送对应的 Notification。在前一步的处理中，会将变更保存在虚拟文件系统（VFS）中。Server 端会根据新的源代码，进行重新编译，保存新的语义模型，以供下一个请求做处理。

3.3 错误处理：这里的错误并非指 Server 端的运行错误，而是代码编译中的语法、语义错误，编译警告等。Client 端并没有对应的请求类型来请求这些错误，而是由 Server 端主动发送 Diagnostics。因此，在发生变更后，同步地将错误信息更新至 Client 端。

## 遇到的问题

### 1. 为什么需要虚拟文件系统？

在最初的设计中，并没有考虑使用虚拟文件系统。我们每次从文件系统中获取源代码，进行编译和分析。对于一些“静态”的任务，如跳转，可以在变更代码后保存到文件系统，然后再进行跳转的操作。配合到 VS Code 的自动保存功能，体验上并没有明显的差距。但对于代码补全这一功能，IDE 中输入的补全trigger（如 “.”）会触发文件变更的通知和代码补全的请求，但对应的代码还未保存到文件系统中，编译后的语义模型无法做对应的分析。因此，我们借助 Rust Analyzer 对应的 vfs 的create，在 Server 端引入了虚拟文件系统，将编译的入口从文件路径变为了 source code。Client 端输入代码后，文件变更的通知会先更新虚拟文件系统，重新编译文件，生成新的语义模型，然后再处理补全请求。

### 2. 如何处理不完整的代码？

我们遇到的另一个比较大的问题是如何处理不完整的代码。同样的，对于跳转这类“静态”的任务，可以假定代码是完整、正确的。但对于补全操作，如以下代码，希望在输入.后，补全字符串的函数。对于编译流程，第二行实际上是不完整的代码，无法编译出正常的 AST 树。

```Rust
s: str = "hello kcl"
len = s.
```

为此，我们在 KCL 的编译中实现了语法和语义上的多种错误恢复，保证编译过程始终能产生完整的 AST 和符号表。在这个例子中，我们新增了一个表示空的 AST 节点作为占位符，使得第二行能够生成完整的 AST。在处理补全的请求时，会根据 s 的类型和其他语义信息，补全函数名、schema attr 或 pkg 中定义的 schema 名。

> Rust Analyzer architecture:
>
> Architecture Invariant: parsing never fails, the parser produces (T, Vec&lt;Error&gt;) rather than Result&lt;T, Error&gt;.

## 总结与展望

KCL 的 IDE 插件目前已经实现高亮、跳转、补全、Outline、悬停、错误提示等功能。这些功能提升了 KCL 用户的开发效率。然而，作为一款 IDE 插件，它的功能还不够完整。在未来的开发中，我们会继续完善，未来的工作有以下几个方向：

- 更多的语言能力：提供更多的功能，如代码重构，错误的quick fix，代码 fmt等，进一步完善功能，提升开发效率
- 更多的 IDE 接入：目前，KCL 虽然提供了 LSP，只接入了 VS Code，未来会基于 LSP 的能力为 KCL 用户提供更多选择。
- AI 能力的集成：目前，ChatGPT 风靡全网，各行各业都在关注。我们也在探索 AI×KCL 的结合，提供更智能的研发体验。总之，我们会继续完善和优化 KCL 的 IDE 插件，让它更加成熟和实用。为KCL用户带来更加方便和高效的开发体验。
  如果您有更多的想法和需求，欢迎在 KCL Github 仓库发起 Issue 或讨论，也欢迎加入我们的社区进行交流 🙌 🙌 🙌
