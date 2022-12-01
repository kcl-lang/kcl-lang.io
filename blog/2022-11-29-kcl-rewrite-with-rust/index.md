---
slug: 2022-kcl-rewrite-with-rust
title: 40x Faster! We rewrote our project with Rust
authors:
  name: Pengfei, Xu
  title: KCL Team Member
tags: [KCL, Rust, Performance, Programming Language, Compiler]
---

## Introduction

Rust has quietly become one of the most popular programming languages. As an emerging system language, Rust has many characteristics, such as the memory security mechanism, performance advantages close to C/C++, excellent developer community, experience of documents, tool chains and IDEs. This blog will introduce the process of using Rust to rewrite the project and gradually implementing the production environment, as well as the reasons for choosing Rust in the rewrite process, the problems encountered, and the results of using Rust to rewrite.

The project we are using Rust to develop is called [KCL](https://github.com/KusionStack/KCLVM). (KCL) is an open source constraint-based record and functional language. KCL improves the writing of a large number of complex configurations through mature programming language technology and practice, and is committed to building better modularity, scalability and stability around configuration, simpler logic writing, fast automation and good ecological extensionality. For more specific KCL usage scenarios, please visit the [KCL website](https://kcl-lang.github.io/). This blog will not repeat them too much.

KCL was written in Python before. Considering the user experience, performance and stability, we have decided to rewrite it in Rust, and the following benefits were obtained:

+ Fewer bugs due to Rust's powerful compilation check and error handling.
+ 66% improvement in language end-to-end compilation and execution performance.
+ The performance of the language front-end parser has been improved by 20 times.
+ The performance of the language semantic analyzer has been improved by 40 times.
+ The average memory usage of the language compiler during compilation is half of the original Python version.

## What problems have we encountered

The compiler, build system or runtime uses Rust to do similar things in technology like projects of the same type in the community [deno](https://github.com/denoland/deno), [swc](https://github.com/swc-project/swc), [turbopack](https://github.com/vercel/turbo), [rustc](https://github.com/rust-lang/rust). We used Rust to completely build the front, middle and runtime of the compiler, and achieved some results, but we did not do this about a year ago.

A year ago, we used Python to build the whole implementation of KCL compiler. Although it ran well at the beginning, Python was easy to use, rich in ecology, and the team's research and development efficiency was also very high, with the expansion of the code and the increase of the number of engineers, code maintenance became more difficult.

Although we forced to write Python type annotations in the project and adopted stricter lint tools. Besides, the coverage of code test lines has also reached more than 90%, but there are still many runtime errors, such as Python None empty objects, attributes not found, and so on. We need to be careful when refactoring Python code, which seriously affects the user experience.

In addition, when KCL users are the majority of developers, any errors in the programming language or compiler internal implementation are intolerable, which also brings a series of problems to our user experience. Programs written in Python start slowly, and their performance cannot meet the efficiency demands of online compilation and execution of the automation system, because in our scenario, After users modify KCL code, they need to be able to quickly display the compilation results. Obviously, the compiler written in Python cannot meet the use requirements well.

## Why use Rust

We chose Rust for the following reasons:

+ We used Python, Go and Rust to implement a simple programming language stack virtual machine and made a performance comparison. In this scenario, Go and Rust have similar performance, Python has a large performance gap, and Rust is adopted under comprehensive consideration. The details of the stack virtual machine code implemented by the three languages are here: [https://github.com/Peefy/StackMachine](https://github.com/Peefy/StackMachine).
+ More and more compilers or runtimes of programming languages, especially front-end infrastructure projects, are written or refactored using Rust. In addition, Rust has appeared in infrastructure, database, search engine, network, cloud native, UI, embedded and other fields. At least, the feasibility and stability of the implementation of programming languages have been verified.
+ Considering that the subsequent project development will involve the direction of blockchain and smart contract, and a large number of blockchain and smart contract projects in the community are written by Rust.
+ Better performance and stability can be achieved through Rust, making the system easier to maintain and more robust. At the same time, C APIs can be exposed through FFI for multilingual use and expansion, facilitating ecological expansion and integration.
+ Rust supports WASM in a friendly way. A large number of WASM ecosystems in the community are built by Rust. KCL languages and compilers can be compiled into WASM with the help of Rust and run in browsers.

Based on the above reasons, we chose Rust instead of Go. In the whole rewriting process, we found that Rust's comprehensive quality is really excellent (high performance and enough abstraction). Although there is some cost in some language features, especially the lifetime, it is not rich in ecology.

## What are the difficulties in using Rust

Although we decided to rewrite the entire KCL project with Rust, most team members have no experience in writing a certain project with Rust, and I has only learned [The Rust Programming Language](https://doc.rust-lang.org/book/). I vaguely remember that I gave up when I learned about intelligent pointers such as `Rc` and `RefCell`. At that time, I didn't expect that there would be anything similar to C++ in Rust.

The risk of using Rust is mainly the cost of Rust language learning, which is indeed mentioned in various Rust blogs. Because the overall architecture of the KCL project has not changed much, and some module design and code writing have been optimized for Rust, so the entire rewrite is carried out in the process of learning while practicing. When we first started to use Rust to write the whole project, we still spent a lot of time on knowledge query, compilation and debugging. However, as the project progressed, the difficulties we encountered in our experience when using Rust were mainly mental transformation and development efficiency.

### Mental transformation

First of all, the syntax and semantics of Rust well absorb and integrate the concepts related to the type system in functional programming, such as the Abstract Algebraic Type (ADT). In addition, there is no concept related to "inheritance" in Rust. If you can't understand it well, even ordinary structure definitions in other languages may take a lot of time in Rust. For example, the following Python code may be defined like this in Rust

+ Python

```python
from dataclasses import dataclass

class KCLObject:
    pass

@dataclass
class KCLIntObject(KCLObject):
    value: int

@dataclass
class KCLFloatObject(KCLObject):
    value: float
```

+ Rust

```rust
enum KCLObject {
    Int(u64),
    Float(f64),
}
```

Of course, more time is spent fighting against the error reports of the Rust compiler itself. The Rust compiler will often cause developers to "run into a wall", such as borrowing check errors. Especially for the KCL compiler, its core structure is the Abstract Syntax Tree (AST), which is a recursive and nested tree structure.

It is sometimes difficult to give consideration to the relationship between variable variability and borrowing check in Rust, Just like the scope structure `Scope` defined in KCL compiler, for scenarios with circular references, it is used to display the interdependence of data that needs to be aware of, while making extensive use of intelligent pointer structures commonly used in Rust such as `Rc`, `RefCell` and `Weak`.

```rust
/// A Scope maintains a set of objects and links to its containing
/// (parent) and contained (children) scopes. Objects may be inserted
/// and looked up by name. The zero value for Scope is a ready-to-use
/// empty scope.
#[derive(Clone, Debug)]
pub struct Scope {
    /// The parent scope.
    pub parent: Option<Weak<RefCell<Scope>>>,
    /// The child scope list.
    pub children: Vec<Rc<RefCell<Scope>>>,
    /// The scope object mapping with its name.
    pub elems: IndexMap<String, Rc<RefCell<ScopeObject>>>,
    /// The scope start position.
    pub start: Position,
    /// The scope end position.
    pub end: Position,
    /// The scope kind.
    pub kind: ScopeKind,
}
```

### Development efficiency

The development efficiency of Rust can be described as "restraining first and then improving". At the beginning of the handwritten project, if the team members have not been exposed to the concept of functional programming and related programming habits, the development speed will be significantly slower than Python, Go, Java and other languages. However, once they become familiar with the common methods and best practices of the Rust standard library, as well as the common error modification of the Rust compiler, the development efficiency will be greatly improved, and they can write high-quality, safe and efficient code natively.

For example, I have encountered a Rust lifetime error as shown in the following code. After a long time of troubleshooting, it was found that the lifetime mismatch was caused by forgetting to label lifetime parameters. In addition, the lifetime of Rust is coupled with concepts such as type system, scope, ownership, and borrowing check, resulting in a high cost and complexity of understanding, and error reporting information is often not as obvious as type errors. The lifetime mismatch error reporting information is sometimes slightly inflexible, which may lead to a high cost of troubleshooting. Of course, the efficiency will be improved after more familiar with relevant concepts.

```rust
struct Data<'a> {
    b: &'a u8,
}

// func2 omit lifecycle parameters, and func2 does not.
// The lifecycle of func2 will be deduced as '_ by the Rust compiler by default,
// which may lead to lifetime mismatch error.
impl<'a> Data<'a> {
    fn func1(&self) -> Data<'a> {Data { b: &0 }}
    fn func2(&self) -> Data {Data { b: &0 }}
}
```

## Rewrite revenue ratio using Rust

After several members of the team spent several months using Rust to completely rewrite and stably put it into the production environment for several months, we reviewed the whole process and felt that it was very rewarding.

From a technical perspective, the rewrite process not only trained to quickly learn a new programming language and programming knowledge, but also put them into practice, And the whole rewrite process made us reflect on the unreasonable design of the KCL compiler and modify it. For a programming language, this is a long cycle project. What we learned is that the compiler system is more stable, safe, with clear code, fewer bugs, and better performance.

Although not all modules get 40 times the performance (because the performance bottleneck of some modules, such as the KCL runtime, is the memory deep copy operation), but I personally think it is still worthwhile. And when Rust has been used for a certain period of time, mind and development efficiency are no longer limiting factors.

## Conclusion

I personally think that the most important thing after using Rust to rewrite the project is whether I have learned a new programming language or whether Rust is very popular and we have written many fancy codes using Rust. It really makes the KCL language and compiler more stable, and the startup speed and automation efficiency are no longer troubled. The performance of KCL is better than that of other programming languages in the same type of fields in the community, so that users of our language and tools can experience the improvement. These are all due to Rust's no-GC, high-performance, better error handling, memory management, zero abstraction and other features. In short, as users, they are the biggest beneficiaries.

Finally, if you like the KCL project, or want to use KCL for your own scenarios, or want to use Rust to participate in an open source project, welcome to visit [https://github.com/KusionStack/community](https://github.com/KusionStack/community) to join our community to participate in discussion and co construction 👏👏👏。

## Reference

+ https://github.com/KusionStack/KCLVM
+ https://github.com/Peefy/StackMachine
+ https://doc.rust-lang.org/book/
+ https://github.com/sunface/rust-course
+ https://www.influxdata.com/blog/rust-can-be-difficult-to-learn-and-frustrating-but-its-also-the-most-exciting-thing-in-software-development-in-a-long-time/
