---
slug: 2026-09-25-kcl-0.13.0-release
title: KCL v0.13.0 Release Blog
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

## Introduction

The KCL team is pleased to announce that **KCL v0.13.0 is now available**! This release has brought three key updates to everyone

- _A more expressive and consistent KCL language: ES6-style config entry shorthand, more flexible lambda expressions, friendlier multi-line strings and equality semantics._
- _A more complete standard library and cross-language API: new `reduce`, `json.merge`, `file.readbase64` and `net.is_IPv6` functions, RFC 7396 JSON Merge Patch support, Source Map v3 output, and line-level test coverage._
- _A faster and more reliable toolchain and IDE: significant compilation and evaluation performance improvements, package-wide linting, dry-run formatting, and richer LSP features._

[KCL](https://github.com/kcl-lang) is an open-source, constraint-based record and functional language hosted by Cloud Native Computing Foundation (CNCF). KCL improves the writing of numerous complex configurations, such as cloud-native scenarios, through its mature programming language technology and practice. It is dedicated to building better modularity, scalability, and stability around configurations, simpler logic writing, faster automation, and great built-in or API-driven integrations.

## ❤️ Special Thanks

**We would like to extend our heartfelt thanks to all community contributors who participated in the iteration from version v0.12 to v0.13. The following list is in no particular order.**

_@Peefy, @zong-zhe, @liangyuanpeng, @johngmyers, @priyansh-saxena1, @jfharden, @aliazlan4, @vlada-dudr, @turner-hemmer, @Arpit529Srivastava, @DCchoudhury15, @jschoone, @ytsarev, @f4z3r, @rtainaan, @31puneet, @Viscous106, @56steve, @neo0007777_

## 📚 Key Updates

### 🔧 Core Features

#### Language

- KCL supports **ES6-style shorthand entries** in config and schema instance literals. A bare identifier is equivalent to a `key = key` entry and can be mixed with ordinary entries, e.g., `{ name, age = 18 }` is equivalent to `{ name = name, age = 18 }`.
- **Lambda expressions support braces around the argument list**, which allows arguments to be written on multiple lines. When braces are used, a return type must be provided.

```kcl
func = lambda {
    x: int,
    y: int = 5
} -> int {
    x + y
}
```

- **Multi-line (triple-quoted) strings are automatically dedented**: the common leading whitespace of all non-empty lines is stripped, so embedded text can be indented naturally with the surrounding code.

```kcl
s = """
  foo
  bar
"""  # "foo\nbar\n"
```

- The **`!=` operator now supports lists, dicts and schemas** in addition to primitive types, e.g. `{} != {k = "v"}` and `[0] != [1]`.
- **Quantifier expressions (`all`/`any`/`filter`/`map`) support selector expressions as the iteration target**, including safe navigation selectors, so nested collections can be iterated directly, e.g. `all y in data?.items { y > 0 }`.
- The YAML output can opt into **multi-line block-scalar strings** via the new `multiline_string` encode option, and YAML block-scalar trailing newlines are preserved.
- Fixed `math.floor` to return an integer instead of a float.
- Fixed string formatting to apply **width, alignment and fill** specifiers to string values, e.g. `"{:*^10}".format("hi")` yields `"****hi****"`.
- Fixed a series of evaluator issues around lazy scope caching, schema attribute overrides, mixin replay, forward references and config entries shadowing enclosing schema attributes, making evaluation results more stable and predictable.

#### Toolchain

- **`kcl lint ./...`**: the lint command now supports the `./...` pattern to lint all KCL packages under the current or a given directory, one package per directory, like `go build ./...`.
- **`kcl fmt --dry-run`**: report the files that require formatting without modifying them, which is convenient for CI checks. The formatter also honors `.editorconfig` indentation settings, keeps inline trailing comments on the same line, and leaves the source unchanged when parsing fails.
- **`kcl test` provides line-level coverage**: the test API collects per-file line coverage information for test runs.
- **Bundle a KCL program into a single file** for easy distribution and execution.
- **Performance**: this release includes a large set of performance improvements — a faster hash map for compiler indexes, small-string optimization for config keys, monotonic AST indices instead of UUIDs, cached path canonicalization and package resolution during loading, memoized fully-qualified-name lookups with incremental updates, and skipping unused package compilation passes. Compilation and evaluation are observably faster on medium and large projects.
- Release artifacts now cover more platforms, including Linux glibc 2.17 and musl (Alpine Linux) builds.

#### IDE

- The KCL language server can **run unit tests by clicking a CodeLens** above each test function.
- The language server can **auto-update dependencies through the `kcl mod` toolchain** and reacts to `kcl.mod`/`kcl.yaml` modification events.
- The language server **walks up the directory tree to find the `kcl.mod`/`kcl.yaml`/`kcl.work` workspace** root, respects `.gitignore` in the workspace file watcher, and speeds up import completion.
- Fixed inherited attribute lookup on schema resolution, wrong import completions, and missing schema type recovery in the language server.

#### API

- **Source Map v3 output**: `kcl run --sourcemap <file>` writes a Source Map v3 document alongside the generated YAML, so downstream tooling can resolve generated lines back to the originating `.k` file, line and column.
- **Schema type API extensions**: the `KclType` schema type now carries **index signature** and **function type** information, and a `__kcl_info_meta__` marker is emitted for attributes decorated with `@info(type="attr")`.
- **New `GetSchemaTypeMappingUnderPath` RPC**: returns schema type mappings keyed by package name. Different from `GetSchemaTypeMapping`, schemas imported from external dependency packages are keyed under their own package name instead of being flattened into `__main__`.
- The **C API honors the `error_format` option** on the error envelope, supporting machine-readable diagnostic output formats (`pretty`, `short`, `arcanist`, `sarif`).
- `ExecProgramArgs` supports running with only `k_code_list`, and unrequested format encoders are skipped when `--format` is set.

### 📦️ Standard Libraries and Third-Party Libraries

#### Standard Libraries

- New builtin function **`reduce`** that applies a reducer function cumulatively to the items of a list.

```kcl
reduce(lambda acc: int, item: int -> int { acc * item }, [2, 3, 4])  # 24
```

- New `json` module function **`merge`** implementing [RFC 7396 JSON Merge Patch](https://datatracker.ietf.org/doc/html/rfc7396). A `None`/`Undefined` value in the patch removes the key, dicts are merged recursively, and other values replace the original value.

```kcl
import json

result = json.merge({a = 1, b = {c = 2}}, {b = {c = None, d = 3}})
# {"a": 1, "b": {"d": 3}}
```

- New `file` module function **`readbase64`** that reads a file as raw bytes and returns the contents encoded as a base64 string, which is binary-safe for images and other non-UTF-8 files.
- New `net` module function **`is_IPv6`**, and `to_IP16` was renamed to **`to_IP6`** with correct IPv4-mapped IPv6 conversion.
- `datetime.now` accepts an optional **`ticks`** argument to format an arbitrary epoch (seconds since the Unix epoch) instead of the current time, and `datetime` date validation is enhanced.
- Fixed `net.to_IP4`/`to_IP6` parsing issues and clarified the UUID version in the `crypto` module documentation.

#### Third-Party Libraries

- The `k8s` package received patch version updates across 1.14 - 1.31 and fixed apimachinery import aliases.
- `external-secrets` was upgraded to 2.9.0.
- Crossplane providers were updated, including `crossplane_provider_keycloak` v2.24.1, `crossplane-provider-kubernetes` v1.2.1, `crossplane-provider-openstack` v0.10.0 and `crossplane-provider-http` v1.0.14 with cluster/namespaced structures.
- `git-promoter` was updated to 0.36.0.

### ☸️ Ecosystem Integration

- [Upbound](https://www.upbound.io/) has been added to [ADOPTERS.md](https://github.com/kcl-lang/kcl/blob/main/ADOPTERS.md).
- Added the [KubeStellar Console](https://kubestellar.io/) guided install reference.

### 📖 Documentation Updates

- The language specification documents the config entry shorthand, the lambda argument braces, the multi-line string dedenting, the `!=` semantics on lists, dicts and schemas, and the selector expression quantifier targets.
- The system package reference documents the new `reduce`, `json.merge`, `file.readbase64`, `net.is_IPv6`, `net.to_IP6` and `datetime.now(ticks)` functions.
- The multi-language API reference is synchronized with the v0.13.0 protobuf service definition, including `GetSchemaTypeMappingUnderPath` and the test coverage messages, and the Go API reference is regenerated.
- The CLI reference documents the new `--dry-run` flag of `kcl fmt`, the `./...` pattern of `kcl lint`, and the refreshed flags and examples of `kcl run` and `kcl vet`.

## 🌐 Other Resources

🔥 Check out the [KCL Community](https://github.com/kcl-lang/community) and join us 🔥

For more resources, refer to:

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
