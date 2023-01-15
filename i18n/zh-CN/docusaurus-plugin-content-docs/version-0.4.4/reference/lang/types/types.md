# 类型系统

本文档描述 KCL 的类型系统，包括：

+ 类型规则
+ 类型检查
+ 类型转换
+ 类型推导

## 类型规则

### 基础定义

#### 断言

$S$ 的所有自由变量都定义在 $\Gamma$ 中

$$
\Gamma \vdash S
$$

$\Gamma$ 是一个变量的类型声明环境(well-formed environment)，如：$x_1:T_1$, ..., $x_n:T_n$

$S$ 的断言有三种形式：

**环境断言** 断言表示 $\Gamma$ 是良构类型 (well-formed type)

$$
\Gamma \vdash ◇
$$

**良构类型断言** 在环境 $\Gamma$ 下，$nat$ 是类型表达式

$$
\Gamma \vdash nat
$$

**类型判断(断言** 在环境 $\Gamma$ 下，$E$ 具有类型 $T$

$$
\Gamma \vdash E: T
$$

#### 推理规则

表示法

$$
\frac{\Gamma \vdash S_1, ..., \Gamma \vdash S_n}{\Gamma \vdash S}
$$

推理规则中的 $u$, $v$, $w$ 用于表示变量，$i$, $j$, $k$ 用于表示整数，$a$, $b$ 用于表示浮点数，$s$ 用于表示字符串，$c$ 代表常量（整数、浮点数、字符串、布尔）的字面值, $f$ 用于表示函数, $T$, $S$, $U$ 用于表示类型。

## 环境规则

Env ⌀

$$
\frac{}{⌀ \vdash ◇ }
$$

## 类型定义

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

## 类型判断规则

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

Literal 类型是基础类型的值类型，Union 类型是类型的组合类型，Void、Any、Nothing 是特殊的类型指代，本身没有直接的值表达式对应关系。

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

算数运算符

Expr op, op $\in$ {-, /, %, **, //}

$$
\frac{\Gamma \vdash E_1: T \ \ \ \Gamma \vdash E_2: T \ \ \ T \in \{integer, float\}}{\Gamma \vdash E_1 \ op \ E_2: T}
$$

Expr +

$$
\frac{\Gamma \vdash E_1: T \ \ \ \Gamma \vdash E_2: T \ \ \ T \in \{integer, float, string, listof(T_1)\}}{\Gamma \vdash E_1 \ + \ E_2: T}
$$

Expr *

$$
\frac{\Gamma \vdash E_1: T_1 \ \ \ \Gamma \vdash E_2: T_2 \ \ \ \ (T_1==T_2 \in \{integer, float\}) \ or \ (T_1 == interger \ and \ T_2 \ \in \ \{string, listof(T_3)\}) \ or \ (T_2 == interger \ and \ T_1 \ \in \ \{string, listof(T_3)\})} {\Gamma \vdash E_1 \ * \ E_2: T}
$$

示例

Expr %

$$
\frac{\Gamma \vdash E_1: interger \ \ \ \Gamma \vdash E_2: integer}{\Gamma \vdash E_1 \ \% \ E_2: interger}
$$

逻辑运算符

Expr op, op $\in$ \{or, and\}

$$
\frac{\Gamma \vdash E_1: boolean \ \ \ \Gamma \vdash E_2: boolean}{\Gamma \vdash E_1 \ op \ E_2: boolean}
$$

示例

Expr and

$$
\frac{\Gamma \vdash E_1: boolean \ \ \ \Gamma \vdash E_2: boolean}{\Gamma \vdash E_1 \ and \ E_2: boolean}
$$

比较运算符

Expr op, op $\in$ \{==, !=, <, >, <=, >=\}

$$
\frac{\Gamma \vdash E_1: T \ \ \ \Gamma \vdash E_2: T}{\Gamma \vdash E_1 \ op \ E_2: boolean}
$$

示例

Expr >

$$
\frac{\Gamma \vdash E_1: boolean \ \ \ \Gamma \vdash E_2: boolean}{\Gamma \vdash E_1 \ > \ E_2: boolean}
$$

位运算符

Expr op, op $\in$ {&, ^, ~, <<, >>}

$$
\frac{\Gamma \vdash E_1: integer \ \ \ \Gamma \vdash E_2: integer}{\Gamma \vdash E_1 \ op \ E_2: integer}
$$

Expr |

$$
\frac{\Gamma \vdash E_1: T \ \ \ \Gamma \vdash E_2: T \ \ \ T \in \{integer, listof(T_1), dictof(T_k, T_v), structof(K_1=T_1, ..., K_n=T_n)\}}{\Gamma \vdash E_1 \ | \ E_2: T}
$$

成员运算符

Expr op, op $\in$ {in, not in}

$$
\frac{\Gamma \vdash E_1: string \ \ \ \Gamma \vdash E_2: T \ \ \ T \in \{dictof, structof\}}{\Gamma \vdash E_1 \ op \ E_2: bool}
$$

Expr op, op $\in$ {in, not in}

$$
\frac{\Gamma \vdash E_1: T \ \ \ \Gamma \vdash E_2: listof(S), T \sqsubseteq S}{\Gamma \vdash E_1 \ op \ E_2: bool}
$$

身份运算符

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

### Union 规则

List Union

$$
\frac{\Gamma \vdash \ listof(T) \ \ \ \Gamma \vdash \ listof(S)}{\Gamma \vdash \ listof(unionof(T, S))}
$$

Dict Union

$$
\frac{\Gamma \vdash \ dictof(T_1, T_2) \ \ \ \Gamma \vdash \ dictof(S_1, S_2)}{\Gamma \vdash \ dictof(unionof(T_1, S_1), unionof(T_2, S_2))}
$$

Struct Union

给定两个结构体 $structof(K_{1}: T_{1}, ..., K_{n}: T_{n})，structof(H_{1}: S_{1}, ..., H_{m}: S_{n})$

定义他们的 union 类型:

$$
structof(J_{1}: U_{1}, ..., J_{p}: U_{n}) = structof(K_{1}: T_{1}, ..., K_{n}: T_{n}) \bigcup structof(H_{1}: S_{1}, ..., H_{m}: S_{n})
$$

例如：

$$
structof() \ \bigcup \ structof(H_{1}: T_{1}, ..., H_{m}: T_{n}) = structof(H_{1}: T_{1}, ..., H_{m}: T_{n})
$$

$$
structof(K_{1}: T_{1}, ..., K_{n}: T_{n}) \ \bigcup \ structof(H_{1}: S_{1}, ..., H_{m}: S_{n}) = structof(K_1: T_1) :: (structof(K_{2}: T_{2}, ..., K_{n}: T_{n}) \ \bigcup \ structof(H_{1}: S_{1}, ..., H_{m}: S_{n}))
$$

其中把 "::" 表示把一个对偶加入到一个结构的操作，定义如下:

$$
structof(K_{1}: T_{1}) :: structof() = structof(K_{1}: T_{1})
$$

$$
structof(K_{1}: T_{1}) :: structof(K_{1}: T_{1}', ..., K_n: T_{n}) = structof(K_{1}: union\_op(T_{1}, T_{1}'), ..., K_{n}: T_{n})
$$

$$
structof(K_{1}: T_{1}) :: structof(K_{2}: T_{2}, ..., K_n: T_{n}) = structof(K_{2}: T_2) :: structof(K_{1}: T_1) :: structof(K_{3}: T_3, ..., K_{n}: T_{n})
$$

基于此，两个 Struct 的 union 定义为：

$$
\frac{\Gamma \vdash structof(K_{1}: T_{1}, ..., K_{n}: T_{n}) \ \Gamma \vdash structof(H_{1}: S_{1}, ..., H_{m}: S_{n}) \ structof(J_{1}: U_{1}, ..., J_{p}: U_{n}) = structof(K_{1}: T_{1}, ..., K_{n}: T_{n}) \bigcup structof(H_{1}: S_{1}, ..., H_{m}: S_{n})}{\Gamma \vdash structof(J_{1}: U_{1}, ..., J_{p}: U_{n}))}
$$

其中 $union\_op(T_1, T_2)$ 表示对相同 $K_i$ 的不同类型的判断操作：

+ 当 $T_1$ 与 $T_2$ 有偏序关系时， 如果 $T_1 \sqsubseteq T_2$ 时，返回 $T_2$，否则返回 $T_1$，即取最小上界
+ 当 $T_1$ 与 $T_2$ 不存在偏序关系时，有三种可选的处理逻辑：
  + 结构体 union 失败，返回 type_error
  + 返回后者的类型，此处为 $T_2$
  + 返回类型 $unionof(T_1, T_2)$

此处需要根据实际需求选择适当的处理方式。

结构体继承可以看做一种特殊的 union，整体逻辑与 union 相似，但在 $union\_op(T_1, T_2)$ 中对相同 $K_i$ 的不同类型的判断操作如下：

+ 当 $T_1$ 与 $T_2$ 有偏序关系且 $T_1 \sqsubseteq T_2$ 时，返回 $T_1$，即仅当 $T_1$ 是 $T_2$ 的下界时以下界 $T_1$ 为准
+ 否则返回 type_error

通过这样的继承设计可以实现分层的、自下而上逐层收缩的类型定义。

## Operation

KCL 支持对结构体属性进行如 `p op E` 形式的操作。 即对给定结构体 $A: structof(K_{1}: T_{1}, ..., K_{n}: T_{n})$, 对结构体中的路径 `p` 以 `E` 的值进行指定的操作（如 union，assign，insert 等）。

定义如下更新操作：

$$
\frac{{\Gamma\vdash A: structof(K_{1}: T_{1}, ..., K_{n}: T_{n})}  {\Gamma\vdash p \in (K_{1}, ..., K_{n})} \ {\Gamma\vdash e:T}   k \neq k_1, ..., k \neq k_n}
{ A \{p \ op \ e\}:\{K_1:T_1, ..., K_n:T_n\}∪\{p:T\}}
$$

即对路径 $p$ 进行操作本质上是对两个结构体的一种 union，对同名属性类型 union 时的规则根据情况而定。例如路径 $p$ 是一个可用作字段名的标识符 $p=k_1$，并且结构体 A 中字段名也是 $k_1$,它的类型为 $T_1$，并且表达式 $e$ 的类型也为 $T_1$ ,那么

$$
\frac{{\Gamma\vdash A: structof(K_{1}: T_{1}, ..., K_{n}: T_{n})}  {\Gamma\vdash p = K_{1}} \ {\Gamma\vdash e:T_1}   k \neq k_1, ..., k \neq k_n}
{ A \{p \ op \ e\}:\{K_1:T_1, ..., K_n:T_n\}}
$$

注意：

+ 此处表达式 $e$ 的类型 $T_1$ 同原先同名属性 $K_1$ 的具有相同的类型。可根据实际情况需要适当放松，如 $e$ 的类型 $\sqsubseteq T_1$ 即可。
+ 对于多层结构体嵌套的操作，递归的使用以上规则即可。

## 类型偏序

### 基础类型

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

### 字面值类型

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

### 联合类型

$$
Type \ X \sqsubseteq Type \ Union(X, Y)
$$

### 自反

$$
Type \ X \sqsubseteq Type \ X
$$

示例

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

### 传递

$$
Type \ X \sqsubseteq Type \ Z \ if \ Type \ X \sqsubseteq Type \ Y \ and \ Type \ Y \sqsubseteq \ Type \ Z
$$

### 包含

$$
Type \ List(T_1) \sqsubseteq Type \ List(T_2) \ if \ T_1 \sqsubseteq T_2
$$

$$
Type \ Dict(T_{k1}, T_{v1}) \sqsubseteq Type \ Dict(T_{k2}, T_{v2}) \ if \ T_{k1} \sqsubseteq T_{k2} \ and \ T_{v1} \sqsubseteq T_{v1}
$$

$$
Type \ Structure(K_1: T_{a1}, K_2: T_{a2}, ..., K_n: T_{an}) \sqsubseteq Type \ Structure(K_1: T_{b1}, K_2: T_{b2}, ..., K_n: T_{bn}) \ if \ T_{a1} \sqsubseteq T_{b1} \ and \ T_{a2} \sqsubseteq T_{b2} \ and \ ... \ and \ T_{an} \sqsubseteq T_{bn}
$$

### 继承

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

## 相等性

交换律

$$
Type \ Union(X, Y) == Type \ Union(Y, X)
$$

示例

$$
Type \ Union(Int, Bool) == Type \ Union(Bool, Int)
$$

结合律

$$
Type \ Union(Union(X, Y), Z) == Type \ Union(X, Union(Y, Z))
$$

示例

$$
Type \ Union(Union(Int, String), Bool) == Type \ Union(Int, Union(String, Bool))
$$

幂等性

$$
Type \ Union(X, X) == Type \ X
$$

示例

$$
Type \ Union(Int, Int) == Type \ Int
$$

偏序推导

$$
Type \ Union(X, Y) == Type \ Y \ if \ X \sqsubseteq Y
$$

示例

假设 Struct A 继承 Struct B

$$
Type \ Union(A, B) == Type \ B
$$

幂等性是偏序自反的一个特例

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

### 偏序检查

$$
Type \ X == Type \ Y \ if \ Type \ X \sqsubseteq Type \ Y \ and \ Type \ Y \sqsubseteq \ Type \ X
$$

## 基础方法

+ sup(t1: T, t2: T) -> T: 根据类型偏序计算两类型 t1, t2 的最小上界。需要动态创建 union type。
+ typeEqual(t1: T, t2: T) -> bool: 比较两类型 t1, t2 是否相等。
+ typeToString(t: T) -> string: 自顶向下递归解析并转化类型成对应的字符串类型。

### Sup Function

+ 暂不考虑类型参数，条件类型等特性
+ 使用一个有序集合存储 UnionType 的所有类型
+ 使用一个全局的 Map 根据 UnionType 的名称存储产生的所有 UnionType
+ 根据偏序关系计算类型之间的包含关系

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

## 类型检查

### 类型检查器

类型检查器通过语法制导翻译的方式，自顶向下遍历语法树，并根据上下文有关的**定型规则**来判定程序构造是否为良类型程序。

类型检查器依赖类型规则，类型环境 $\Gamma$ 的信息记入符号表。对类型表达式采用抽象语法，如 listof(T)。类型检查失败时产生 type_error，并根据语法上下文产生错误信息。

### 基础方法

1. isUpperBound(t1, t2): supUnify(t1, t2) == t2
2. supUnify(t1, t2):

- 对于基础类型，根据偏序关系计算 sup(t1, t2)
- 对于 list、 dict、 Struct, 递归地对其中元素的类型进行 supUnify
- 不存在偏序关系时，返回 Nothing

### 检查逻辑

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

根据每条双目运算符的推理规则推导，以 '+' 为例

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

根据每条双目运算符的推理规则推导，以 '%' 为例

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

## 类型转换

### 基础定义

通过语法制导翻译的方式，根据运算符特征，对参与运算的值类型进行自动类型转换

### 转换规则

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

## 类型推导

### 基础定义

+ 在类型信息不完全的情况下类型规则推导、重建类型
+ 自底向上推导并重建数程序中的数据结构类型，如基础类型，list, dict, Struct

### 基础方法

1. typeOf(expr, subst): 输入为表达式和代换规则集合，返回 expr 的类型和新的代换规则集合
2. unifier(t1, t2, subst, expr) 用 t1=t2 尝试代换，如果代换成功（未出现且无冲突），则将 t1=t2 加入 subst 并返回 subst。否则报错已出现或有冲突。

### 推导逻辑

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

### 示例

#### 正常推导

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

+ [https://en.wikipedia.org/wiki/Type_system](https://en.wikipedia.org/wiki/Type_system)
+ Pierce, Benjamin C. (2002). Types and Programming Languages. MIT Press.
+ [https://www.cs.cornell.edu/courses/cs4110/2010fa/](https://www.cs.cornell.edu/courses/cs4110/2010fa/)
+ https://www.cmi.ac.in/~madhavan/courses/pl2009/lectureNotes/lecture-Notes/
+ [https://www.typescriptlang.org/docs/handbook/basic-types.html](https://www.typescriptlang.org/docs/handbook/basic-types.html)
+ [https://www.typescriptlang.org/docs/handbook/advanced-types.html](https://www.typescriptlang.org/docs/handbook/advanced-types.html)
