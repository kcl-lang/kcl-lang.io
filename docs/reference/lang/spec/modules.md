---
title: "Modules"
linkTitle: "Modules"
type: "docs"
weight: 2
description: Modules
---

## Modules and the Import System

KCL code is organized in **modules**. For code in one module to access the code defined in another module, a process called **importing** must be used.

Importing is undertaken at compile-time in KCL. The advantage is to have static checking enabled.

A regular KCL module is a file on the file system. It is required to have a `.k` suffix.

## Packages

To help manage modules and provide a naming hierarchy, KCL has the concept of packages. In KCL, a package maps to exactly a file system directory, and a regular module maps to a file.

Files directly under a package are considered parts of the package, instead of individual regular modules.

Packages can have sub-packages.

Packages are special modules:

- All packages in KCL are modules.
- A single-file module can never be a package.

All modules have a name.

Sub package names are separated from their parent package name by dots.

To summary, a regular KCL module is a `.k` file, and a package is a directory on the file system. All `.k` files directly under the directory are included in the package, other files are ignored. If the directory has subdirectories, they become sub-packages as long as there are `.k` files underneath.

### Intra-Package Name Space Sharing

Inside a package, all `.k` files are considered parts of the package, instead of regular modules. Code in these files share a single name space and can access names defined in other files, without explicitly granted.

### Package Initialization

A package can have the initialization code. The code must exist in only one of the `.k` files under this package. The interpreter guarantees that the initialization code is executed after all definitions.

## Searching

The searching begins when an `import` statement is used to import a module.

### Module Cache

In KCL, only standard system modules are cached. When a cached module is imported, the cached version is used. In other words, KCL runtime would not create another copy of the standard system module in memory.

However, other modules are uncached. Importing a module multiple time would create multiple instances of the module.

### Module Names

An `import` statement specifies the name of the module to import. The syntax is:

```
import <module_name> [as <alias name>]
```

The rule to search with the module name is very simple:

- **Step 1**: Searches the module name from the **standard system modules**, then **plugins modules**.
  - See **standard system modules** and **plugins modules** for more details. If matched, the module is imported. Otherwise, continue to **Step 2**.
- **Step 2**. Whether a module name starts with a `.` is checked. If yes, the name is a so-called relative pathname, and we go to **Step 5**. Otherwise, continue to **Step 3**.
- **Step 3**: If the module name does not start with any `.`, then the compiler searches the nearest `root path` directory from this directory to the parent, and find the module according to the name just from the `root path`. If no `root path` is found, find the module according to the name from the folder the `.k` file including this `import` statement exists.
  - **root path**: the directory contains a `kcl.mod` file. If matched, the module is imported. Otherwise, continue to **Step 4**.
- **Step 4**: Then the compiler checks if the name is the name of any library module that requires explicit loading. If matched, the library module is imported. Otherwise, continue to **Step 6**.
- **Step 5**. For relative importing, find the module according to the name from the folder the `.k` file including this `import` statement exists. Interpret leading dots using the following rule:
- One dot: Ignore.
- Tow or more dots: Suppose there are `n` leading dots, then the searching starts at `n - 1` levels above this folder. If matched, the module is imported. Otherwise, continue to **Step 6**.
- **Step 6**. Module not found, report an error.

Do case-sensitive search when the operating system allows. If case-sensitive search is not allowed, search directories before regular files.

In KCL, the `from <> import <>` is unsupported, and relative import is performed with the `import <>` syntax.

### Uniqueness of Module

Each module has a unique location path in its scope, so that a module or package could be located with a unique location path, such as `a.b.c`.

Searching by location path should be supported by the kcl compiler, which needs to provide corresponding searching features through the command line and api form.

## Standard System Packages

KCL supports a few standard system modules. [Here](docs/reference/model/overview) is the full list of these standard system modules.

### The Built-in System Package

KCL provides a list of built-in system modules, which are loaded automatically and can be directly used without providing any module name. For example, `print` is a widely used built-in module.

The following is the full list of these built-in system modules:

- print()
  - The print function.
- multiplyof(a, b)
  - Check if the modular result of a and b is 0
- isunique(inval)
  - Check if a list has duplicated elements
- len(inval)
  Return the length of a value
- abs(x)
  Return the absolute value of the argument.
- all(iterable)
  Return True if bool(x) is True for all values x in the iterable. If the iterable is empty, return True.
- any(iterable)
  Return True if bool(x) is True for any x in the iterable. If the iterable is empty, return False.
- bin(number)
  Return the binary representation of an integer.
- hex(number)
  Return the hexadecimal representation of an integer.
- oct(number)
  Return the octal representation of an integer.
- ord(c) -> int
  Return the Unicode code point for a one-character string.
- sorted(iterable)
  Return a new list containing all items from the iterable in ascending order. A custom key function can be supplied to customize the sort order, and the reverse flag can be set to request the result in descending order.
- range(start, end, step=1)
  Return the range of a value with start, end and step parameter.
- min(iterable)
  With a single iterable argument, return its smallest item. The default keyword-only argument specifies an object to return if the provided iterable is empty. With two or more arguments, return the smallest argument.
- max(iterable)
  With a single iterable argument, return its biggest item. The default keyword-only argument specifies an object to return if the provided iterable is empty. With two or more arguments, return the largest argument.
- sum(iterable, start)
  Return the sum of a 'start' value (default: 0) plus an iterable of numbers. When the iterable is empty, return the start value. This function is intended specifically for use with numeric values and may reject non-numeric types.
- pow(x, y, z)
  Equivalent to `x**y` (with two arguments) or `x**y % z` (with three arguments). Some types, such as ints, are able to use a more efficient algorithm when invoked using the three argument form.
- round(number, ndigits)
  Round a number to a given precision in decimal digits. The return value is an integer if ndigits is omitted or None. Otherwise the return value has the same type as the number. ndigits may be negative.
- typeof(x: any, \*, full_name: bool = False) -> str
  Return the type of the value 'x' at runtime. When the 'full_name' is 'True', return the full package type name such as `pkg.schema`.

### Plugin Modules

KCL compiler needs to provide the ability to dynamically expand and load plugin modules without modifying the compiler itself. KCL compiler needs to support flexible pluggable module extension mechanism, so that KCL users can use more abundant built-in function capabilities to simplify writing.

KCL compiler needs to ensure the stability and safety of the expansion mechanism, without affecting the core of the compiler.

Searching extended plugin module is performed after the standard system module. The standard system module has a higher priority in naming. If it exists a standard or built-in system module with the same name, the extended plugin module will be ignored.

Importing and using the extended plugin module should be consistent with the standard or built-in system module.

### Replacing Standard System Packages

Replacing standard system modules is not allowed.

## Examples

We show more module features through an example.

Suppose we have the following directories and files:

```
    .
    ├── mod1.k
    ├── mod2.k
    ├── pkg1
    │   ├── def1.k
    │   ├── def2.k
    │   └── def3init.k
    └── pkg2
        ├── file2.k
        └── subpkg3
            └── file3.k
```

From the structure we can see that `pkg1` and `pkg2` are two packages, `subpkg3` is a subpackage of `pkg2`, and `mod1.k` and `mod2.k` are regular modules.

### Importing a Standard System Package

The following statement can import the standard system module `math`

```python
import math
```

This is the only way to import a standard system module. After importing a standard system module, functions, variables and schemas defined in it can be used. For example, the following statement uses the `log10` function
defined in `math`

```python
a = math.log10(100) # a is 2 after computation.
```

### Importing a Regular Module

In `mod1.k`, we can import `mod2` using one of the following syntaxes.

```python
import mod2
```

```python
import .mod2
```

The difference is that in the first syntax, the KCL compiler will first try to check if `mod2` matches any of the standard system modules' name. Since it does not match any standard system module's name, the statement will check the directory where `mod1.k` resists in, like what the second statement does.

Suppose in `mod2.k` there is a definition of a variable::

```python
a = 100
```

After importing `mod2`, we can access `a` in `mod1.k` using the following syntax

```python
b = mod2.a
```

### Importing a Package

In `mod1.k`, we can import `pkg1` using one of the following syntaxes.

```python
import pkg1
```

```python
import .pkg1
```

The difference is that in the first syntax, the KCL compiler will first try to check if `pkg1` matches any of the standard system modules' name. Since it does not match any standard system module's name, the statement will check the directory where `mod1.k` resists in, like what the second statement does.

We can use similar statements to import `pkg2`. Note that importing `pkg2` will not import `subpkg3`.

The name of the package is the name of the imported module.

Suppose in `file2.k` that is inside `pkg2` there is a definition to variable `foo`

```python
foo = 100
```

This variable can be used in `mod1.k` after importing `pkg2` like the following

```python
bar = pkg2.foo
```

### Importing a Subpackage

To import `subpkg3` from `mod1.k`, one of the following statements can be used.

```python
import pkg2.subpkg3
```

```python
import .pkg2.subpkg3
```

The behaviors of these statements are identical.

The name of the subpackage is the name of the imported module.

Suppose in `file3.k` that is inside `subpkg3` there is a definition to variable `foo`

```python
foo = 100
```

This variable can be used in `mod1.k` after importing `subpkg3` like the following

```python
bar = subpkg3.foo
```

### Relative Importing

Relative importing is useful when there is code trying to import modules that does not exist recursively inside the current directory.

For example, the following statements, if written in `file3.k`, can be used to import `pkg2`, `pkg1` and `mod2` respectively.

```python
import ...pkg2 # Go two levels up then import pkg2
import ...pkg1 # Go two levels up then import pkg1
import ...mod2 # Go two levels up then import mod2
```

### Importing from a Root Path

Suppose we have a `kcl.mod` file in the directory to mark it as a root path, then we have the following files:

```
    .
    |── kcl.mod
    ├── mod1.k
    ├── mod2.k
    ├── pkg1
    │   ├── def1.k
    │   ├── def2.k
    │   └── def3init.k
    └── pkg2
        ├── file2.k
        └── subpkg3
            └── file3.k
```

In `pkg1` `def1.k`, we can import `pkg2.subpkg3` `file3` using the following syntaxes.

```python
import pkg2.subpkg3.file3
```

Importing from the root path is very convenient when the code is trying to import modules from a directory needs to look up multiple directories above this directory. At also, it is helpful to organize a large number of files in a root directory.

### Importing a Module Inside a Package

Note that `subpkg3` is only implemented with one file `file3.k`. The file can be regarded as a regular module and imported directly.

In `mod1.k`, the importing statement would be::

```python
import pkg2.subpkg3.file3
```

Different from importing `subpkg3`, now the name of the module is `file3`. We can access the variable `foo` defined in this module with the following
statement

```python
bar = file3.foo
```

### Precedence of Importing

When an import statement specifies a package to import, the virtual machine first looks for a directory named according to the import statement in the file system.

If such a directory is not found, the virtual machine looks for a single file module.

For example, when the statement `import a.b.c` appears, the virtual machine first looks for the directory `a/b/c` from the directory of the current file. If `a/b/c` is not found, the virtual machine looks for a file named `a/b/c.k`. If the file is also absent, an error is reported.

### Package Implemented with Multiple Files

Package `pkg1` is implemented with multiple KCL files.

Multiple files can be used to define variables, schemas and functions, and they can access names defined in other files of this package.

For example, suppose `def1.k` defines a variable `foo`, `def2.k` defines `bar`, and `def3init.k` defines a variable `baz`, when `pkg1` is imported by `mod1.k`, all these variable can be used

```python
import pkg1
a = pkg1.foo + pkg1.bar + pkg1.baz
```

Inside a module, names defined in a file can be accessed in another file without further importing. For example, suppose `bar` in `def2.k` would invoke `foo` defined in `def1.k`, it can directly use `foo` like the following

```python
bar = foo + 1
```
