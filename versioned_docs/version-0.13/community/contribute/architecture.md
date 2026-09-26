---
sidebar_position: 3
---

# Architecture: Component Dependency Graph

This document explains how the main KCL repositories depend on each other. It is written for developers who want to know where a feature lives or which repo to send a PR to.

## Repositories and Their Roles

| Repository | Language | Role |
|---|---|---|
| [kcl-lang/kcl](https://github.com/kcl-lang/kcl) | Rust | The compiler core: parser, semantic analysis and evaluator implemented as a set of `kcl-*` Rust crates (`kcl-lib`, `kcl-sema`, `kcl-evaluator`, `kcl-parser`, ...). The `kcl-lib` crate builds the Rust API and the shared library (`libkcl.so` / `libkcl.dylib` / `kcl.dll`). Also ships `kcl-language-server`, `kcl-fmt`, `kcl-vet` and `kcl-test`. |
| [kcl-lang/lib](https://github.com/kcl-lang/lib) | Go (embedded) | Prebuilt `libkcl` shared libraries (`libkcl.so` / `libkcl.dylib` / `kcl.dll`) for each supported OS/arch, published as the `kcl-lang.io/lib` Go module. |
| [kcl-lang/kcl-go](https://github.com/kcl-lang/kcl-go) | Go | The Go SDK. Calls into the Rust core through cgo and the embedded shared library. Provides the `Run`/`Test`/`Format`/`Vet`/`Validate`/`ListVariables` APIs and the base for most downstream tools. |
| [kcl-lang/kpm](https://github.com/kcl-lang/kpm) | Go | The KCL package manager (`kcl mod ...`). Depends on kcl-go, and therefore transitively on libkcl. |
| [kcl-lang/cli](https://github.com/kcl-lang/cli) | Go | The user-facing `kcl` command. Embeds kcl-go (run/test/fmt/vet/...) and kpm (mod/init/registry...). |
| [kcl-lang/kcl-openapi](https://github.com/kcl-lang/kcl-openapi) | Go | Converts OpenAPI / JSON Schema to KCL schemas, used by the import tooling. |
| [kcl-lang/kcl-plugin](https://github.com/kcl-lang/kcl-plugin) | Go | SDK for writing KCL plugins in Go. |

## Dependency Graph

```
                      +-------------------------------+
                      |      kcl-lang/kcl (Rust)      |
                      |  kcl-* crates: parser/sema/   |
                      |  evaluator + libkcl cdylib    |
                      |  kcl-language-server, kcl-fmt |
                      +---------------+---------------+
                                      | builds
                                      v
                      +-------------------------------+
                      |  kcl-lang/lib: prebuilt       |
                      |  libkcl per OS/arch           |
                      +---------------+---------------+
                                      | cgo embed (kcl-lang.io/lib)
                                      v
              +-------------------------------------------+
              |      kcl-lang.io/kcl-go (Go SDK)          |
              |  Run/Test/Format/Vet/Validate/...         |
              +-------+---------------------------+-------+
                      |                           |
              +-------v------+          +---------v--------+
              | kcl-lang.io/ |          | kcl-lang.io/cli  |
              | kpm (kcl mod)|          |  (the kcl CLI)   |
              +--------------+          +---------+--------+
                                                  | uses
        +---------------------------+-------------+----------------+
        v                           v                              v
 kcl-lang.io/kcl-openapi    kcl-lang.io/kcl-plugin    kcl-operator, helm-kcl,
 (OpenAPI <-> KCL schemas)   (Go plugin SDK)           crossplane-kcl, IDE
                                                          extensions, ...
```

## Reading the Graph

- **All execution paths bottom out in the Rust core.** Every `kcl` command, every Go API call, and every IDE operation is ultimately served by the evaluator in `kcl-lang/kcl`, reached either through the `libkcl` CLI driver or through cgo + the `libkcl` shared library built by the `kcl-lib` crate.
- **kcl-go is the single integration point for the Go ecosystem.** kpm, the `kcl` CLI, and third-party tools like kcl-operator all depend on it, so an SDK-level fix in kcl-go propagates to every downstream tool on the next release.
- **Version numbers move together.** The Go modules (`kcl-lang.io/kcl-go`, `kcl-lang.io/kpm`, ...) tag releases that track the KCL compiler version, so `kcl-go v0.12.x` pairs with the `v0.12.x` compiler core and the matching `libkcl` binaries in kcl-lang/lib.
- **Where to contribute what:**
  - Language features, the evaluator, the LSP, fmt/vet rules → [kcl-lang/kcl](https://github.com/kcl-lang/kcl/blob/main/docs/dev_guide/1.about_this_guide.md) (KEP process for language changes).
  - Go API surface, `kcl run` behavior as seen by Go programs → [kcl-lang/kcl-go](https://github.com/kcl-lang/kcl-go).
  - `kcl mod`, OCI packaging, the registry client → [kcl-lang/kpm](https://github.com/kcl-lang/kpm).
  - CLI flags, command layout, release packaging of the `kcl` binary → [kcl-lang/cli](https://github.com/kcl-lang/cli).

See [How to Contribute Code](./contribute-code.md) for the full workflow.

---

*Added following [kcl-lang/kcl-lang.io#485](https://github.com/kcl-lang/kcl-lang.io/issues/485).*
