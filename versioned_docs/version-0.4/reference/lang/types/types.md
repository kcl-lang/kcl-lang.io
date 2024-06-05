# Type System

This document describes the type system of KCL, including:

- Type rules
- Type checking
- Type conversion
- Type inference

## Type Rules

### Basic Definition

#### Assertion

All free variables of $S$ are defined in $\Gamma$

$$
\Gamma \vdash S
$$

$\Gamma$ is a variable's well-formed environment, such as $x_1:T_1$, ..., $x_n:T_n$

The assertion of $S$ has three forms:

**Environment assertion** indicates that $\Gamma$ is a well-formed type.

$$
\Gamma \vdash ◇
$$

**Well-formed type assertion**. In the environment $\Gamma$, $nat$ is a type expression.

$$
\Gamma \vdash nat
$$

**Typing judgment assertion**. In the environment $\Gamma$，$E$ has the type $T$.

$$
\Gamma \vdash E: T
$$

#### Inference Rules

Representation

$$
\frac{\Gamma \vdash S_1, ..., \Gamma \vdash S_n}{\Gamma \vdash S}
$$

In the inference rules, $u$, $v$, and $w$ are used to represent variables, $i$, $j$, $k$ are used to represent integers, $a$ and $b$ are used to represent floating point numbers, $s$ is used to represent strings, $c$ is used to represent literal values of constants (integers, floating point numbers, strings, boolean), $f$ is used to represent functions, $T$, $S$, $U$ are used to represent types.

## Environment Rules

Env ⌀

$$
\frac{}{⌀ \vdash ◇ }
$$

## Type Definitions

Type Bool

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash boolean}
$$

Type Int

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash integer}
$$

Type Float

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash float}
$$

Type String

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash string}
$$

Type Literal

$$
\frac{ c \in \{boolean, integer, float, string\}}{\Gamma \vdash literalof(c)}
$$

Type List

$$
\frac{\Gamma \vdash T \ T \neq Void}{\Gamma \vdash listof(T) }
$$

Type Dict

$$
\frac{\Gamma \vdash T_1 \ \Gamma \vdash T_2\ T_1 \neq Void \ \ T_2 \neq Void}{\Gamma \vdash dictof(T_k=T_1, T_v=T_2)}
$$

Type Struct

$$
\frac{\Gamma \vdash T_{1} \ ... \  \Gamma \vdash T_{n} \  \ T_i \neq Void \  K_1 \neq K_n}{\Gamma \vdash structof(K_1 : T_{1}, ... , K_n : T_{n})}
$$

Type Union

$$
\frac{\Gamma \vdash T_1 \ ... \ \Gamma \vdash T_n \ \ T_i \neq Void}{\Gamma \vdash unionof(T_1, ..., T_n)}
$$

Type None

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash None}
$$

Type Undefined

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash Undefined}
$$

Type Void

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash Void}
$$

Type Any

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash Any}
$$

Type Nothing

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash Nothing}
$$

## Typing Judgment Rules

### Operand Expr

Exp Truth

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash true: boolean}
$$

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash false: boolean}
$$

Exp Int

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash int: integer}
$$

Exp Flt

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash flt: float}
$$

Exp Str

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash str: string}
$$

Exp None

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash none: none}
$$

Exp Undefined

$$
\frac{\Gamma \vdash ◇}{\Gamma \vdash undefined: undefined}
$$

Expr ListExp

$$
\frac{\Gamma \vdash E_1: T_1 \ E_2: T_2 \ ... \ E_n: T_n}{\Gamma \vdash [E_1, E_2, ..., E_n]: listof \ sup(T_1, T_2, ..., T_n)}
$$

Expr ListComp

$$
\frac{\Gamma \vdash E_1: T_1 \ \Gamma \vdash v: T \ \Gamma \vdash E_2: listof \ T \ \Gamma \vdash E_3: boolean}{\Gamma \vdash [E_1 \ for \ v \ in \ E_2 \ if \ E_3]: listof(T_1) }
$$

Expr DictExp

$$
\frac{\Gamma \vdash E_{k1}: T_{k1} \ \Gamma \vdash E_{v1}: T_{v1} \ ... \ \Gamma \vdash E_{kn}: T_{kN} \ \Gamma \vdash E_{vn}: T_{vN}}{\Gamma \vdash \{E_{k1}: E_{v1}, ..., E_{{kn}}: E_{vn}\}: dictof(T_{k}=sup(T_{k1}, T_{k2}, ... T_{kn}), \ T_{v}=sup(T_{v1}, T_{v2}, ..., T_{vn}))}
$$

Expr DictComp

$$
\frac{\Gamma \vdash E_1: T_{rki} \  \Gamma \vdash E_2: T_{rvi} \ \Gamma \vdash v_1: T_k \ \Gamma \vdash v_2: T_v \ \Gamma \vdash E_3: dictof(T_{k}, \ T_{v}) \ \Gamma \vdash E_4: boolean}{\Gamma \vdash \{E_1:E_2 \ for \ (v_1, v_2) \ in \ E_3 \ if \ E_4\}: dictof(T_{k}=sup(T_{rk1}, T_{rk2}, ..., T_{rkn}), T_{v}=sup(T_{rv1}, T_{rv2}, ..., T_{rvn})) }
$$

Expr StructExpr

$$
\frac{\Gamma \vdash E_{1}: T_{1} \ ... \ \Gamma \vdash E_{n}: T_{n} \ K_1 \neq K_n}{\Gamma \vdash \{K_{1} = E_{1}, ..., K_{{n}} = E_{n}\}: structof(K_1 : T_{1}, ... , K_n : T_{n})}
$$

The literal type is the value type of basic type, the union type is the combination type of types, void, any, nothing are special type references, and there is no direct value expression correspondence.

### Primary Expr

Expr Index

$$
\frac{\Gamma \vdash E: listof(T) \  \Gamma \vdash Index: integer}{\Gamma \vdash E[Index]: T}
$$

Expr Call

$$
\frac{\Gamma \vdash E_1: T_1 \rightarrow T_2 \ \Gamma \vdash E_2: T_1}{\Gamma \vdash E_1 \ (E_2): T_2}
$$

Expr List Selector

$$
\frac{\Gamma \vdash E: listof(T) \ \Gamma \vdash Index: integer}{\Gamma \vdash E.[Index]: T}
$$

Expr Dict Selector

$$
\frac{\Gamma \vdash E: dictof(T_k = T_1, T_v=T_2) \ \Gamma \vdash S_1: string  \  ...  \  \Gamma \vdash S_n: string}{\Gamma \vdash E.\{S_1, ..., S_n\}: dictof(T_k = T_1, T_v=T_2)}
$$

Expr Struct Selector

$$
\frac{\Gamma \vdash E: structof(K_1 : T_{1}, ... , K_n : T_{n}) \ \Gamma \vdash K_i: string}{\Gamma \vdash E.K_i: T_{i}}
$$

### Unary Expr

Expr +

$$
\frac{\Gamma \vdash E: T \ \ \ T \in \{integer, float\}}{\Gamma \vdash \ +E: T}
$$

Expr -

$$
\frac{\Gamma \vdash E: T \ \ \ T \in \{integer, float\}}{\Gamma \vdash \ -E: T}
$$

Expr ~

$$
\frac{\Gamma \vdash E: integer}{\Gamma \vdash \ ~E: integer}
$$

Expr not

$$
\frac{\Gamma \vdash E: boolean}{\Gamma \vdash \ not \ E: boolean}
$$

### Binary Expr

Expr op, op $\in$ {-, /, %, \*\*, //}

$$
\frac{\Gamma \vdash E_1: T \ \ \ \Gamma \vdash E_2: T \ \ \ T \in \{integer, float\}}{\Gamma \vdash E_1 \ op \ E_2: T}
$$

Expr +

$$
\frac{\Gamma \vdash E_1: T \ \ \ \Gamma \vdash E_2: T \ \ \ T \in \{integer, float, string, listof(T_1)\}}{\Gamma \vdash E_1 \ + \ E_2: T}
$$

Expr \*

$$
\frac{\Gamma \vdash E_1: T_1 \ \ \ \Gamma \vdash E_2: T_2 \ \ \ \ (T_1==T_2 \in \{integer, float\}) \ or \ (T_1 == interger \ and \ T_2 \ \in \ \{string, listof(T_3)\}) \ or \ (T_2 == interger \ and \ T_1 \ \in \ \{string, listof(T_3)\})} {\Gamma \vdash E_1 \ * \ E_2: T}
$$

Expr %

$$
\frac{\Gamma \vdash E_1: interger \ \ \ \Gamma \vdash E_2: integer}{\Gamma \vdash E_1 \ \% \ E_2: interger}
$$

Expr op, op $\in$ \{or, and\}

$$
\frac{\Gamma \vdash E_1: boolean \ \ \ \Gamma \vdash E_2: boolean}{\Gamma \vdash E_1 \ op \ E_2: boolean}
$$

示例

Expr and

$$
\frac{\Gamma \vdash E_1: boolean \ \ \ \Gamma \vdash E_2: boolean}{\Gamma \vdash E_1 \ and \ E_2: boolean}
$$

Expr op, op $\in$ \{==, !=, <, >, <=, >=\}

$$
\frac{\Gamma \vdash E_1: T \ \ \ \Gamma \vdash E_2: T}{\Gamma \vdash E_1 \ op \ E_2: boolean}
$$

Expr >

$$
\frac{\Gamma \vdash E_1: boolean \ \ \ \Gamma \vdash E_2: boolean}{\Gamma \vdash E_1 \ > \ E_2: boolean}
$$

Expr op, op $\in$ {&, ^, ~, <<, >>}

$$
\frac{\Gamma \vdash E_1: integer \ \ \ \Gamma \vdash E_2: integer}{\Gamma \vdash E_1 \ op \ E_2: integer}
$$

Expr |

$$
\frac{\Gamma \vdash E_1: T \ \ \ \Gamma \vdash E_2: T \ \ \ T \in \{integer, listof(T_1), dictof(T_k, T_v), structof(K_1=T_1, ..., K_n=T_n)\}}{\Gamma \vdash E_1 \ | \ E_2: T}
$$

Expr op, op $\in$ {in, not in}

$$
\frac{\Gamma \vdash E_1: string \ \ \ \Gamma \vdash E_2: T \ \ \ T \in \{dictof, structof\}}{\Gamma \vdash E_1 \ op \ E_2: bool}
$$

$$
\frac{\Gamma \vdash E_1: T \ \ \ \Gamma \vdash E_2: listof(S), T \sqsubseteq S}{\Gamma \vdash E_1 \ op \ E_2: bool}
$$

Expr op $\in$ {is, is not}

$$
\frac{\Gamma \vdash E_1: T \ \ \ \Gamma \vdash E_2: T}{\Gamma \vdash E_1 \ op \ E_2: bool}
$$

### IF Expr

Expr If

$$
\frac{\Gamma \vdash E_1: boolean \ \ \ \Gamma \vdash E_2: T \ \ \ \Gamma \vdash E_3: T}{\Gamma \vdash if \ E_1 \ then \ E_2 \ else \ E_3: T}
$$

### Stmt

Stmt If

$$
\frac{\Gamma \vdash E_1: boolean \ \ \ \Gamma \vdash S_1: Void \ \ \ \Gamma \vdash S_2: Void}{\Gamma \vdash if \ E_1 \ then \ S_1 \ else \ S_2: Void}
$$

Stmt Assign

$$
\frac{\Gamma \vdash id: T_0 \ \ \ \Gamma \vdash T_1 \ \ \ \Gamma \vdash E: T_2}{\Gamma \vdash id: T_1 \ = \ E  : Void}
$$

Type Alias

$$
\frac{\Gamma \vdash id: T_0 \ \ \ \Gamma \vdash T_1}{\Gamma \vdash type \ id \ = \ T_1 : Void}
$$

## Union

List Union

$$
\frac{\Gamma \vdash \ listof(T) \ \ \ \Gamma \vdash \ listof(S)}{\Gamma \vdash \ listof(unionof(T, S))}
$$

Dict Union

$$
\frac{\Gamma \vdash \ dictof(T_1, T_2) \ \ \ \Gamma \vdash \ dictof(S_1, S_2)}{\Gamma \vdash \ dictof(unionof(T_1, S_1), unionof(T_2, S_2))}
$$

Struct Union

Define two structures: $structof(K_{1}: T_{1}, ..., K_{n}: T_{n})，structof(H_{1}: S_{1}, ..., H_{m}: S_{n})$

Define their union types:

$$
structof(J_{1}: U_{1}, ..., J_{p}: U_{n}) = structof(K_{1}: T_{1}, ..., K_{n}: T_{n}) \bigcup structof(H_{1}: S_{1}, ..., H_{m}: S_{n})
$$

Example

$$
structof() \ \bigcup \ structof(H_{1}: T_{1}, ..., H_{m}: T_{n}) = structof(H_{1}: T_{1}, ..., H_{m}: T_{n})
$$

$$
structof(K_{1}: T_{1}, ..., K_{n}: T_{n}) \ \bigcup \ structof(H_{1}: S_{1}, ..., H_{m}: S_{n}) = structof(K_1: T_1) :: (structof(K_{2}: T_{2}, ..., K_{n}: T_{n}) \ \bigcup \ structof(H_{1}: S_{1}, ..., H_{m}: S_{n}))
$$

where "::" denotes the operation of adding a dual to a structure, which is defined as follows:

$$
structof(K_{1}: T_{1}) :: structof() = structof(K_{1}: T_{1})
$$

$$
structof(K_{1}: T_{1}) :: structof(K_{1}: T_{1}', ..., K_n: T_{n}) = structof(K_{1}: union\_op(T_{1}, T_{1}'), ..., K_{n}: T_{n})
$$

$$
structof(K_{1}: T_{1}) :: structof(K_{2}: T_{2}, ..., K_n: T_{n}) = structof(K_{2}: T_2) :: structof(K_{1}: T_1) :: structof(K_{3}: T_3, ..., K_{n}: T_{n})
$$

Based on this, the union of two structures is defined as:

$$
\frac{\Gamma \vdash structof(K_{1}: T_{1}, ..., K_{n}: T_{n}) \ \Gamma \vdash structof(H_{1}: S_{1}, ..., H_{m}: S_{n}) \ structof(J_{1}: U_{1}, ..., J_{p}: U_{n}) = structof(K_{1}: T_{1}, ..., K_{n}: T_{n}) \bigcup structof(H_{1}: S_{1}, ..., H_{m}: S_{n})}{\Gamma \vdash structof(J_{1}: U_{1}, ..., J_{p}: U_{n}))}
$$

where $union\_op(T_1, T_2)$ denotes different types of judgment operations for the same $K_i$.

- When $T_1$ and $T_2$ have the partial order relation. If $T_1 \sqsubseteq T_2$, return $T_2$, otherwise return $T_1$, which is the minimum upper bound
- When $T_1$ and $T_2$ have no partial order relationship, there are three optional processing logic:
  - Structure union failed, return a type error.
  - Return the type of the latter $T_2$.
  - Return the type $unionof (T_1, T_2)$.

Here, we need to choose the appropriate processing method according to the actual needs.

Structure inheritance can be regarded as a special union. The overall logic is similar to that of union, but in $union\_op(T_1, T_2)$ for the same $K_i$, the different types of judgment operations are as follows:

- When $T_1$ and $T_2$ have the partial order relation and $T_1 \sqsubseteq T_2$, return $T_1$, that is, only if $T_1$ is the lower bound of $T_2$, the lower bound of $T_1$ shall prevail.
- Otherwise, a type error is returned.

Through such inheritance design, we can achieve hierarchical, bottom-up and layer-by-layer contraction of type definition.

## Operation

KCL supports operations on structure attributes in the form of $p op E$. That is, for the given structure $A: structof(K_{1}: T_{1}, ..., K_{n}: T_{n})$, the path $p$ in the structure is specified with the value of $E$ (such as union, assign, insert, etc.).

Define the following update operations:

$$
\frac{{\Gamma\vdash A: structof(K_{1}: T_{1}, ..., K_{n}: T_{n})}  {\Gamma\vdash p \in (K_{1}, ..., K_{n})} \ {\Gamma\vdash e:T}   k \neq k_1, ..., k \neq k_n}
{ A \{p \ op \ e\}:\{K_1:T_1, ..., K_n:T_n\}∪\{p:T\}}
$$

That is to say, the operation on the path $p$ is essentially a union of two structures. The rules for the same name attribute type union depend on the situation. For example, the path $p$ is an identifier $p=k_1$ that can be used as a field name $k_1$, and the field name in structure A is also $k_1$, its type is $T_1$, and the type of the expression $e$ is also $T_1$, then

$$
\frac{{\Gamma\vdash A: structof(K_{1}: T_{1}, ..., K_{n}: T_{n})}  {\Gamma\vdash p = K_{1}} \ {\Gamma\vdash e:T_1}   k \neq k_1, ..., k \neq k_n}
{ A \{p \ op \ e\}:\{K_1:T_1, ..., K_n:T_n\}}
$$

Note:

- The type $T_1$ of the expression $e$ have the same type with the original attribute of the same name $K_1$. It can be relaxed appropriately according to the actual situation, such as the type of $e$ $\sqsubseteq T_1$ is enough.
- For the operation of nested multi-layer structures, the above rules can be used recursively.

## Type Partial Order

### Basic Types

$$
Type \ T \sqsubseteq Type \ Any
$$

$$
Type \ Nothing \sqsubseteq Type \ T
$$

$$
Type \ Nothing \sqsubseteq Type \ Bool \sqsubseteq Type \ Any
$$

$$
Type \ Nothing \sqsubseteq Type \ Int \sqsubseteq Type \ Any
$$

$$
Type \ Nothing \sqsubseteq Type \ Float \sqsubseteq Type \ Any
$$

$$
Type \ Int \sqsubseteq Type \ Float
$$

$$
Type \ Nothing \sqsubseteq Type \ String \sqsubseteq Type \ Any
$$

$$
Type \ Nothing \sqsubseteq Type \ Literal \sqsubseteq Type \ Any
$$

$$
Type \ Nothing \sqsubseteq Type \ List \sqsubseteq Type \ Any
$$

$$
Type \ Nothing \sqsubseteq Type \ Dict \sqsubseteq Type \ Any
$$

$$
Type \ Nothing \sqsubseteq Type \ Struct \sqsubseteq Type \ Any
$$

$$
Type \ Nothing \sqsubseteq Type \ None \sqsubseteq Type \ Any
$$

$$
Type \ Nothing \sqsubseteq Type \ Void \sqsubseteq Type \ Any
$$

$$
Type \ Nothing \sqsubseteq Type \ Any
$$

### Literal Type

$$
Type \ Literal(Bool) \sqsubseteq Type \ Bool
$$

$$
Type \ Literal(Int) \sqsubseteq Type \ Int
$$

$$
Type \ Literal(Float) \sqsubseteq Type \ Float
$$

$$
Type \ Literal(String) \sqsubseteq Type \ String
$$

### Union Type

$$
Type \ X \sqsubseteq Type \ Union(X, Y)
$$

### Introspect

$$
Type \ X \sqsubseteq Type \ X
$$

Example

$$
Type \ Bool \sqsubseteq Type \ Bool
$$

$$
Type \ Int \sqsubseteq Type \ Int
$$

$$
Type \ Float \sqsubseteq Type \ Float
$$

$$
Type \ String \sqsubseteq Type \ String
$$

$$
Type \ List \sqsubseteq Type \ List
$$

$$
Type \ Dict \sqsubseteq Type \ Dict
$$

$$
Type \ Struct \sqsubseteq Type \ Struct
$$

$$
Type \ Nothing \sqsubseteq Type \ Nothing
$$

$$
Type \ Any \sqsubseteq Type \ Any
$$

$$
Type \ Union(Type Int, Type Bool) \sqsubseteq Type \ Union(Type Int, Type Bool)
$$

### Transmit

$$
Type \ X \sqsubseteq Type \ Z \ if \ Type \ X \sqsubseteq Type \ Y \ and \ Type \ Y \sqsubseteq \ Type \ Z
$$

### Contained

$$
Type \ List(T_1) \sqsubseteq Type \ List(T_2) \ if \ T_1 \sqsubseteq T_2
$$

$$
Type \ Dict(T_{k1}, T_{v1}) \sqsubseteq Type \ Dict(T_{k2}, T_{v2}) \ if \ T_{k1} \sqsubseteq T_{k2} \ and \ T_{v1} \sqsubseteq T_{v1}
$$

$$
Type \ Structure(K_1: T_{a1}, K_2: T_{a2}, ..., K_n: T_{an}) \sqsubseteq Type \ Structure(K_1: T_{b1}, K_2: T_{b2}, ..., K_n: T_{bn}) \ if \ T_{a1} \sqsubseteq T_{b1} \ and \ T_{a2} \sqsubseteq T_{b2} \ and \ ... \ and \ T_{an} \sqsubseteq T_{bn}
$$

### Inheritance

$$
Type \ Struct \ A \sqsubseteq Type \ Struct \ B \ if \ A \ inherits \ B
$$

### None

$$
Type \ None \sqsubseteq Type \ X, X \notin \{Type \ Nothing, \ Type \ Void\}
$$

### Undefined

$$
Type \ Undefined \sqsubseteq Type \ X, X \notin \{Type \ Nothing, \ Type \ Void\}
$$

## Equality

- Commutative law

$$
Type \ Union(X, Y) == Type \ Union(Y, X)
$$

Example

$$
Type \ Union(Int, Bool) == Type \ Union(Bool, Int)
$$

- Associative law

$$
Type \ Union(Union(X, Y), Z) == Type \ Union(X, Union(Y, Z))
$$

Example

$$
Type \ Union(Union(Int, String), Bool) == Type \ Union(Int, Union(String, Bool))
$$

- Idempotent

$$
Type \ Union(X, X) == Type \ X
$$

Example

$$
Type \ Union(Int, Int) == Type \ Int
$$

Partial order derivation

$$
Type \ Union(X, Y) == Type \ Y \ if \ X \sqsubseteq Y
$$

Example

Assume that Struct A inherits Struct B

$$
Type \ Union(A, B) == Type \ B
$$

Idempotency is a special case of partial order reflexivity

### List

$$
Type \ List(X) == Type \ List(Y) \ if \ X == Y
$$

### Dict

$$
Type \ Dict(T_k, T_v) == Type \ Dict(S_k, S_v) \ if \ T_k == S_k \ and \ T_v == S_v
$$

### Struct

$$
Type \ Struct(K_1: T_{1}, K_2: T_{2}, ..., K_n: T_{n}) == Type \ Struct(K_1: S_{1}, K_2: S_{2}, ..., K_n: S_{n}) \ if \ T_{1} == S_{1} \ and \ ... \ and \ T_{n} == S_{n}
$$

### Partial Order Checking

$$
Type \ X == Type \ Y \ if \ Type \ X \sqsubseteq Type \ Y \ and \ Type \ Y \sqsubseteq \ Type \ X
$$

## Basic Methods

- `sup(t1: T, t2: T) -> T`: Calculate the minimum upper bound of two types `t1` and `t2` according to the type partial order. The union type needs to be created dynamically.
- `typeEqual(t1: T, t2: T) -> bool`: Compare whether the two types `t1` and `t2` are equal.
- `typeToString(t: T) -> string`: Resolve and convert the type to the corresponding string type recursively from top to bottom.

### Sup Function

- Type parameters, condition types and other characteristics are not considered temporarily.
- Use an ordered collection to store all types of `UnionType`.
- Use a global map to store all generated union types according to the name of `UnionType`.
- Calculate the inclusion relationship between types according to the partial order relationship.

```go
// The Sup function returns the minimum supremum of all types in an array of types
func Sup(types: T[]) -> T {
    typeOf(types, removeSubTypes=true)
}

// Build a sup type from types [T1, T2, ... , Tn]
func typeOf(types: T[], removeSubTypes: bool = false) -> T {
    assert isNotNullOrEmpty(types)
    // 1. Initialize an ordered set to store the type array
    typeSet: Set[T] = {}
    // 2. Add the type array to the ordered set for sorting by the type id and de-duplication
    addTypesToTypeSet(typeSet, types)
    // 3. Remove sub types according to partial order relation rules e.g. sub schema types
    if removeSubTypes {
        removeSubTypes(typeSet)
    }
    if len(typeSet) == 1 {
        // If the typeSet has only one type, return it
        return typeSet[0]
    }
    // 4. Get or set the union type from the global union type map
    id := getIdentifierFromTypeSet(typeSet)
    unionType := globalUnionTypeMap.get(id)
    if !unionType {
        unionType = createUnionType(typeSet)  // Build a new union type
        globalUnionTypeMap.set(id, unionType)
    }
    return unionType
}

// Add many types into the type set
func addTypesToTypeSet(typeSet: Set[T], types: T[]) -> void {
    for type in types {
        addTypeToTypeSet(typeSet, type)
    }
}

// Add one type into the type set
func addTypeToTypeSet(typeSet: Set[T], type: T) -> void {
    if isUnion(type) {
        return addTypesToTypeSet(typeSet, toUnionOf(type).types)
    }
    // Ignore the void type check
    if !isVoid(type) {
        // De-duplication according to the type of id
        typeSet.add(type)
    }
}

func removeSubTypes(types: Set[T]) -> void {
    for source in types {
        for target in types {
            if !typeEqual(source, target) {
                // If the two types have an inheritance relationship, the base class is retained, or if the two types have a partial order relationship according to the relation table.
                if (isPartialOrderRelatedTo(source, target)) {
                    types.remove(source)
                }
            }
        }
    }
}

// isPartialOrderRelatedTo function Determine whether two types have a partial order relationship `source \sqsubseteq target`
// according to the partial order relationship table and rules
func isPartialOrderRelatedTo(source: T, target: T) -> bool {
    assert isNotNullOrEmpty(source)
    assert isNotNullOrEmpty(target)
    if isNoneOrUndefined(source) and !isNothing(target) and !isVoid(target) {
        return true
    }
    if isAny(target) {
        return true
    }
    if typeEqual(source, target) {
        return true
    }
    if isUnion(target) and source in target.types {
        return true
    }
    // Literal Type
    if (isStringLiteral(source) and isString(target)) or \
    (isBooleanLiteral(source) and isBool(target)) or \
    (isIntLiteral(source) and isInt(target)) or \
    (isFloatLiteral(source) and isFloat(target)) {
        return true
    }
    if isInt(source) and isFloat(target) {
        return true
    }
    if isList(source) and isList(target) {
        return isPartialOrderRelatedTo(toListOf(source).eleType, toListOf(target).eleType
    }
    if isDict(source) and isDict(target) {
        return isPartialOrderRelatedTo(toDictOf(source).keyType, toDictOf(target).keyType) and isPartialOrderRelatedTo(toDictOf(source).valueType, toDictOf(target).valueType)
    }
    if isStruct(source) and isStruct(target) {
        if isTypeDerivedFrom(source, target) {
            return true
        }
        // Empty Object
        if len(target.keys) == 0 {
            return true
        }
        if any([key Not in source.keys for key in target.keys]) {
            return false
        }
        for key, sourceType in (source.keys, source.types) {
            targetType = getKeyType(target, key) ? getKeyType(target, key) : anyTypeOf()
            if !isPartialOrderRelatedTo(sourceType, targetType) {
                return false
            }
        }
        return true
    }
    return false
}
```

## Type Checking

### Checker

The type checker traverses the syntax tree from top to bottom through syntax-directed translation, and determines whether the program structure is a well-typed program according to context-sensitive training rules.

The type checker depends on type rules, and the information of type environment $\Gamma$ is recorded in the symbol table. Use abstract syntax for type expressions, such as `listof (T)`. When the type check fails, a type mismatch error is generated, and the error message is generated according to the syntax context.

### Basic Methods

1. `isUpperBound(t1, t2): supUnify(t1, t2) == t2`
2. `supUnify(t1, t2):`

- For the foundation type, `sup(t1, t2)` is calculated according to the partial order relationship
- For list, dict, Struct, recursively `supUnify` the types of elements
- When there is no partial order relationship, return `Nothing`

### Checking Logic

#### Operand Expr

$D \to id: T$

```
env.addtype(id.entry, T.type)
```

$T \to boolean$

```
T.type = boolean
```

$T \to integer$

```
T.type = integer
```

$T \to float$

```
T.type = float
```

$T \to string$

```
T.type = string
```

$T \to c, \ c \in \{boolean, integer, float, string\}$

```
T.type = literalof(c)
```

$T \to None$

```
T.type = None
```

$T \to Undefined$

```
T.type = Undefined
```

$T \to \ [T_1]$

```
T.type = listof (T1.type)
```

$T \to { \{T_1: T_2\} }$

```
T.type = dictof (T1.type: T2.type)
```

$T \to { \{N_1: T_1, N2: T_2, ..., N_n: T_n\} }$

```
T.type = structof (N1: T1.type, N2: T2.type, ..., Nn: Tn.type)
```

$E \to id$

```
E.type = env.lookup(id.entry)
```

$E \to [E_1, E_2, ..., E_n]$

```
func listExpr(E) {
    supe = sup([e.type for e in E]])
    E.type = listof(type)
}
```

$E \to [E_1 \ for \ E_2 \ in \ E_3 \ if \ E_4]$

```
func listComp(E) {
    if !typeEqual(E4.type, boolean) {
        raise type_error
    }
    if !isUpperBound(listof(Any), E3.type) {
        raise type_error(E)
    }
    if !isUpperBound(E3.type, E2.type) {
        raise type_error(E)
    }
    E.type = listof(E1.type)
}
```

$E \to \{E_{k1}: E_{v1}, ..., E_{kn}: E_{vn}\}$

```
func dictExpr(E) {
    supk := sup([e.type for e in E.keys()]])
    supv := sup([e.type for e in E.values()]])
    E.type = dictof(supk, supv)
}
```

$E \to \{E_1:E_2 \ for \ (E_3, E_4) \ in \ E_5 \ if \ E_6\}$

```
func dictComp(E) {
    if !typeEqual(E6.type, boolean) {
        raise type_error(E)
    }
    if !isUpperBound(dictof(Any, Any), E5.type) {
        raise type_error(E)
    }
    if !isUpperBound(E5.type, dictof(E3.type, E4.type)) {
        raise type_error(E)
    }
    E.type = dictof(E1.type, E2.type)
}
```

$E \to \{E_{k1}: E_{v1}, ..., E_{kn}: E_{vn}\}$

```
func dictExpr(E) {
    supk := sup(Ek1, ..., Ekn)
    supv = sup(Ev1, ..., Evn)
    E.type = dictof(supk, supv)
}
```

$E \to \{N_{1} = E_{1}, ..., N_{{n}} = E_{n}\}$

```
func structExpr(E) {
    Struct = structof()
    for n, e in E {
        Struct.add(n, e.type)
    }
    E.type = Struct
}
```

#### Primary Expr

$E \to E_1[E_2]$

```
func sliceSuffix(E) {
    if !isUpperBound(listof(Any), E.E1.type) {
        raise type_error(E)
    }
    if typeEqual(E.E2.type, integer) {
        raise type_error(E)
    }
    E.type = E.E1.type.eleType
}
```

$E \to E_1(E_2)$

```
func callSuffix(E) {
    if !typeEqual(E.E1.type, func) {
        raise type_error(E)
    }
    if !isUpperBound(listof(E.E1.arguType), E.E2.type) {
        raise type_error(E)
    }
    E.type = E.E1.returnType
}
```

#### Unary Expr

According to the reasoning rules of each binocular operator, take `+` as an example.

$E \to + E_1$

```
func Plus(E) {
    if !typeEqual(E.E1.type, [integer, float]) {
        raise type_error(E)
    }
    E.type = E.E1.type
}
```

#### Binary Expr

According to the reasoning rules of each binocular operator, take `%` as an example.

$E \to E_1 \ % \ E_2$

```
func Mod(E) {
    if !(typeEqual(E.E1.type, [integer, float]) && typeEqual(E.E2.type, [integer, float])) {
        raise type_error(E)
    }
    E.type = E.E1.type
}
```

#### IF Binary Expr

$E \to if E_1 \ then \ E_2 else \ E_3$

```
func ifExpr(E) {
    if !typeEqual(E.type, boolean) {
        raise type_error(E)
    }
    if !typeEqual(E_2.type, E_3.type) {
        raise type_error(E)
    }
    E.type = E_2.type
}
```

#### Stmt

$S \to if \ E \ then \ S_1 \ else \ S_2$

```
func ifStmt(S) {
    if !typeEqual(S.E.type, boolean) {
        raise type_error(E)
    }
    if !typeEqual(S.S1.type, S.S2.type) {
        raise type_error(E)
    }
    S.type = S.S1.type
}
```

$S \to id: T = E$

$S \to id = T E$

```
func assignStmt(S) {
    tpe := env.lookup(id.entry)
    if tpe != nil && tpe != S.T {
        raise type_error(E)
    }
    if isUpperBound(tpe, E.type) {
        raise type_error(E)
    }
    env.addtype(id.entry, T.type)
}
```

## Type Conversion

### Basic Definition

Through syntax-directed translation, the value types involved in the operation are automatically converted according to the operator characteristics.

### Conversion Rules

$E \to E_1 \ op \ E_2, , op \in \{+, -, *, /, \%, **, //\}$

```
func binOp(E) {
    if E.E1.type == integer and E.E2.type == integer {
        E.type = integer
    } else if E.E1.type == integer and E.E2.type == float {
        E.type = float
    } else if E.E1.type == float and E.E2.type == integer {
        E.type = float
    } else if E.E1.type == float and E.E2.type == float {
        E.type = float
    }
}
```

## Type Inference

### Basic Definition

- Type rule derivation and type reconstruction in case of incomplete type information
- Derive and reconstruct the data structure types in the program from the bottom up, such as basic type, e.g., list, dict and struct types.

### Basic Methods

1. `typeOf(expr, subst)`: The input is the expression and substitution rule set, and the type of expr and the new substitution rule set are returned.
2. `unifier(t1, t2, subst, expr)`: Try substitution with `t1=t2`. If the substitution is successful (no occurrence and no conflict), add `t1=t2` to the subst and return the subst. Otherwise, an error has occurred or there is a conflict.

### Inferential Logic

$E \to id = E_1$

```
func assignExpr(E, subst) {
    return unifier(E.id.type, E.E_1.type, subst, E)
}
```

$unifier(t1, t2, subst, expr) \rightarrow subst$

```
func unifier(t1, t2, subst, expr) {
    t1 = applySubstToTypeEquation(t1, subst)
    t2 = applySubstToTypeEquation(t2, subst)

    if t1 == t2 {
        return subst
    }

    if isTypeVar(t1) {
        if isNoOccur(t1, t2) {
            addTypeEquationToSubst(subst, t1, t2)
            return subst
        } else {
            raise occurrence_violation_error(t1, t2, expr)
        }
    }

    if isTypeVar(t2) {
        if isNoOccur(t2, t1) {
            addTypeEquationToSubst(subst, t2, t1)
            return subst
        } else {
            raise occurrence_violation_error(t2, t1, expr)
        }
    }

    if isList(t1) and isList(t2) {
        return unifier(toListOf(t1).eleType, toListOf(t2).eleType, subst, expr)
    }
    if isDict(t1) and isDict(t2) {
        dict1of := toDictOf(t1)
        dict2of := toDictOf(t2)
        subst = unifier(dict1of.keyType, dict2of.keyType, subst, expr)
        subst = unifier(dict1of.valueType, dict2of.valueType, subst, expr)
        return subst
    }
    if isStruct(t1) and isStruct(t2) {
        Struct1of := tostructof(t1)
        Struct2of := tostructof(t2)
        for key, _ in Struct1of {
            subst = unifier(t1[key].type, t2[key].type, subst, expr)
        }
        return subst
    }

    raise unification_error(t1, t2, expr)
}

func applySubstToTypeEquation(t, subst) {
    // walks through the type t, replacing each type variable by its binding in the substitution
σ. If a variable is Not bound in the substitution, then it is left unchanged.
    if isBasicType(t) {
        return t
    }
    if isList(t) {
        return listOf(applySubstToTypeEquation(toListOf(t).eleType, subst))
    }
    if isDict(t) {
        dictof := toDictOf(t)
        kT := applySubstToTypeEquation(dictof.keyType, subst)
        vT := applySubstToTypeEquation(dictof.valueType, subst)
        return dictOf(kT, vT)
    }
    if isStruct(t) {
        structof := tostructof(t)
        s := structof()
        for key, type in Struct1of {
            kT := applySubstToTypeEquation(type, subst)
            s.add(key, kT)
        }
        return s
    }
    if hasTypeVar(t) {
        for tvar in t.vars {
            if tvar in subst {
                *tvar = subst[tvar]
            }
        }
    }
    return t
}

func addTypeEquationToSubst(subst, tvar, t) {
    // takes the substitution σ and adds the equation tv = t to it
    for _, t in subst {
        for tvar in t.vars {
            tmp := applyOneSubst(tsvar, tvar, t)
            *tvar = tmp
        }
    }
    subst.add(tvar, t)
}

func applyOneSubst(t0, tvar, t1) {
    // substituting t1 for every occurrence of tv in t0.
    if isBasicType(t0) {
        return t0
    }
    if isList(t0) {
        return listOf(applyOneSubst(toListOf(t).eleType, tvar, t1))
    }
    if isDict(t0) {
        dictof := toDictOf(t)
        kT := applyOneSubst(dictof.keyType, tvar, t1)
        vT := applyOneSubst(dictof.valueType, tvar, t1)
        return dictOf(kT, vT)
    }
    if isStruct(t0) {
        structof := tostructof(t)
        s := structof()
        for key, type in Struct1of {
            kT := applyOneSubst(type, tvar, t1)
            s.add(key, kT)
        }
        return s
    }
    if t0 == tvar {
        return t1
    }
    return t0
}

func isNoOccur(tvar, t) {
    // No variable bound in the substitution occurs in any of the right-hand sides of the substitution.
    if isBasicType(t) {
        return true
    }
    if isList(t) {
        return isNoOccur(tvar, toListOf(t).eleType)
    }
    if isDict(t) {
        dictof := toDictOf(t)
        return isNoOccur(tvar, dictof.keyType) and isNoOccur(tvar, dictof.valueType)
    }
    if isStruct(t) {
        structof := tostructof(t)
        noOccur := true
        for _, type in structof {
            noOccur = noOccur and isNoOccur(tvar, type)
        }
        return noOccur
    }
    return tvar != t
}
```

### Example

#### Normal Inference

```
T : {
    a = 1
    b = "2"
    c = a * 2
    d = {
        d0 = [a, c]
    }
}

x: T = {
    a = 10
}
```

#### Occurrence Violation Error

```
T = {
    a = a
}
```

#### Type Unification Error

```
T : {
    a = 1
}

T : {
    a = "1"
}
```

## Reference

- [https://en.wikipedia.org/wiki/Type_system](https://en.wikipedia.org/wiki/Type_system)
- Pierce, Benjamin C. (2002). Types and Programming Languages. MIT Press.
- [https://www.cs.cornell.edu/courses/cs4110/2010fa/](https://www.cs.cornell.edu/courses/cs4110/2010fa/)
- [https://www.typescriptlang.org/docs/handbook/basic-types.html](https://www.typescriptlang.org/docs/handbook/basic-types.html)
- [https://www.typescriptlang.org/docs/handbook/advanced-types.html](https://www.typescriptlang.org/docs/handbook/advanced-types.html)
