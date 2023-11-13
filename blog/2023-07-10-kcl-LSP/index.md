# Rewrite KCL LSP in Rust

The KCL v0.4.6 version has significant updates in language, toolchain, community integration and IDE extension support. In this blog, we'll be discussing the features of the KCL IDE extension and introducing the LSP, as well as talking about the design and implementation of the KCL LSP server and our plans and expectations for the future.

## New Features

In this update, we have released a new KCL VSCode extension and rewritten the LSP server in Rust. We have provided common code assistance features in the IDE, such as highlight, goto definition, completion, outline, hover, diagnostics, and more.

- **Syntax Highlight:**
  ![Highlight](/img/docs/tools/Ide/vs-code/Highlight.png)
- **Goto Definition:** Goto definition of schema, variable, schema attribute, and import pkg.
  ![Goto Definition](/img/docs/tools/Ide/vs-code/GotoDef.gif)
- **Completion:** Keywords completions and dot(`.`) completion.
  ![Completion](/img/docs/tools/Ide/vs-code/Completion.gif)
- **Outline:** Main definition(schema def) and variables in KCL file.
  ![Outline](/img/docs/tools/Ide/vs-code/Outline.gif)
- **Hover:** Identifier information (type and schema documentation).
  ![Hover](/img/docs/tools/Ide/vs-code/Hover.gif)
- **Diagnostics:** Warnings and errors in KCL file.
  ![Diagnostics](/img/docs/tools/Ide/vs-code/Diagnostics.gif)

Welcome to [KCL VSCode extension](https://kcl-lang.io/docs/tools/Ide/vs-code/) to learn more. 👏👏👏

## What is LSP?

In this update, we have implemented the above features based on LSP. LSP stands for Language Server Protocol, which is a protocol for programming language tools that was introduced by Microsoft in 2016. It is easy to understand LSP with a picture on the VSCode website.

![LSP](/img/blog/2023-07-10-kcl-LSP/lsp.png)

By LSP, IDE can communicate with the language server which runs on the backend through the JSON-RPC protocol. The language server can provide capabilities such as code analysis, completion, syntax highlighting, and goto definition. Based on LSP, developers can migrate between different editors and IDEs, reducing the development of language tools from M (number of languages) \* N (number of editors/IDEs) to M + N.

## Why rewrite it in Rust？

The KCL compiler and other tools were originally implemented in Python, and we rewrote its compiler in Rust for performance reasons. After that, we gradually rewrote other tools of KCL, such as testing and formatting tools. In this update, we also rewrote the LSP in consideration of performance issues.

In the past, when the Python version LSP server was processing some complex scenarios (over 200 files), for a request of goto definition, the server-side took more than about 6 seconds from receiving the request to calculating the result and responding. It is almost unavailable. Since the implementation of the server side is mainly based on the lexical analysis and semantic analysis of the front-end and middle-end of the compiler. After we rewrite it in Rust, the performance of this part has been improved by 20 and 40 times, and the remarkable result is that the response time of the server has been greatly improved. Boost, for the same scenario, the response time is reduced to around 100 milliseconds. For some simple scenarios, the response time is only a few milliseconds, which makes the user feel indifferent.

## Design of KCL LSP

The KCL LSP is designed as follows：
![KCL-LSP](/img/blog/2023-07-10-kcl-LSP/kcl-LSP.png)

The main process can be divided into several stages:

1. Initiate a connection and set the LSP capability. In IDE, when opening a specific file (e.g., \*.k for KCL), the IDE will run the local kcl_language_server binary. This binary is distributed with KCL and installed in KCL's bin directory. After the Server starts, it will start a standard IO Connection and wait for the initialization request sent by the IDE Client. After receiving the initialization request, the server will define the information and capabilities of the server and return it to the client to complete the initial connection of the LSP.
2. After the connection is established, the server will start a polling function to continuously receive LSP messages from the client, such as `Notification` (open/close/change/delete files, etc.) and `Request` (goto definition, hover, etc.), as well as messages from the server itself the Task. And uniformly encapsulated into an event (Event) and handed over to the next step for processing.
3. For different events, follow the steps below:

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

3.1 Task distribution: According to the task type, the Task is distributed to different sub-functions. In the sub-function, it will be further distributed to the final processing function based on the type of request or notification, such as processing file changes, processing goto definition requests, etc. These functions will analyze the semantic model (AST, symbol table, error information, etc.) compiled based on the front-end of the compiler, calculate and generate the Response (such as the target position of the goto definition request).

3.2 Change processing: When the user modifies the code or changes the file, the corresponding Notification will be sent. In the previous step of processing, the changes are saved in the virtual file system (VFS). The server side will recompile according to the new source code and save the new semantic model for processing the next request.

3.3 Diagnostics: the diagnostics here do not refer to LSP server, but to the grammatical and semantic errors and warnings when compiling KCL code. The IDE/editor does not have a request to get these errors, but the LSP server actively sends Diagnostics. Therefore, after the change, the error information is updated on the client side synchronously

## Problems

### 1. Why do we need a virtual file system?

In the original design, the use of a virtual file system was not considered. Each time we fetch the source code from the file system, compile and analyze it. For some "static" tasks, such as goto definition, you can save the code to the file system after changing, and then find some variables definitions. Cooperating with the automatic save of VS Code, there is no obvious gap in user experience. However, for tasks such as completion, the input of `.` on the IDE/editor will trigger a file change notification and a request for completion, but the code has not been saved in the file system. Therefore, the semantic model cannot be analyzed correctly. Therefore, we realized the virtual file system with the creation of Rust Analyzer's vfs and changed the compilation entry from the file path to the source code. After the client enters the code, the file change notification will first update the virtual file system, recompile the file, and then process the completion request.

### 2. How to deal with incomplete code?

Another big problem we encountered was how to deal with incomplete code. Likewise, for "static" tasks, e.g., goto definition, the code can be assumed to be complete and correct. But for the request of completion, such as the following code, I hope to complete the function of the string after entering `.`.For the compilation process, the second line is an incomplete code that cannot be compiled into a normal AST tree.

```
s: str = "hello kcl"
len = s.
```

To this end, we have implemented a variety of syntactic and semantic error recovery in KCL compilation, ensuring that the compilation process can always produce a complete AST and symbol table. In this example, we added an empty AST node as a placeholder, so that the second line can generate a complete AST. When processing the completion request, it will complete the function name, schema attr or the schema name defined in pkg according to the type of `s` and other semantic information.

> Rust Analyzer architecture:
>
> Architecture Invariant: parsing never fails, the parser produces (T, Vec&lt;Error&gt;) rather than Result&lt;T, Error&gt;.

## Summary

KCL's IDE extension has already implemented capabilities such as highlighting, goto definition, completion, outline, hovering, and diagnostics. These features improve the development efficiency of KCL users. However, as an IDE extension, its functionality is not complete enough. In the future, we will continue to improve its capabilities. Future work has the following aspects:

- More capabilities: Provide more capabilities, such as code refactoring, error quick fix, code fmt, etc., to further improve capabilities and improve development efficiency
- More IDE Integration: At present, although KCL provides LSP, it only integrates with VS Code. In the future, KCL users will be provided with more choices based on the capabilities of LSP.
- Integration of AI: At present, ChatGPT is popular all over the Internet. We are also exploring the combination of AI×KCL to provide a more intelligent R&D experience.

In summary, we will continue to improve and optimize KCL's IDE extension to make it more powerful and practical. Bring more convenient and efficient development experience to KCL users.
If you have more ideas or needs, welcome to issue or discuss them in the KCL Github repo, and welcome to join our community for communication 🙌 🙌 🙌
