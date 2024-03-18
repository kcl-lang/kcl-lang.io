---
sidebar_position: 0
---

import DocsCard from '@site/src/components/global/DocsCard';
import DocsCards from '@site/src/components/global/DocsCards';

# 概览

KCL 通过内置模块、系统库模块和插件模块提供工程化的扩展能力。

![](/img/docs/reference/lang/model/kcl-module.png)

用户代码中不用导入直接使用 builtin 的函数（比如用 `len` 计算列表的长度、通过 `typeof` 获取值的类型等），而对于字符串等基础类型也提供了一些内置方法（比如转化字符串的大小写等方法）。

对于相对复杂的通用工作则通过标准库提供，比如通过 import 导入 `math` 库就可以使用相关的数学函数，可以通过导入 `regex` 库使用正则表达式库。

## 系统库模块

<DocsCards>
  <DocsCard header="内置函数" href="builtin">
    <p>提供了一系列可以直接使用的内置函数</p>
  </DocsCard>
  <DocsCard header="base64" href="base64">
    <p>提供了 Base64（RFC 3548）数据编码函数。</p>
  </DocsCard>
  <DocsCard header="crypto" href="crypto">
    <p>提供了常见加密算法和协议的实现。</p>
  </DocsCard>
  <DocsCard header="datetime" href="datetime">
    <p>具体的日期/时间和相关类型和函数。</p>
  </DocsCard>
  <DocsCard header="json" href="json">
    <p>提供了与 JSON 相关的编码/解码函数。</p>
  </DocsCard>
  <DocsCard header="manifests" href="manifests">
    <p>提供了结构序列化输出 KCL 数据的能力。</p>
  </DocsCard>
  <DocsCard header="math" href="math">
    <p>提供了常用的数学计算函数。</p>
  </DocsCard>
  <DocsCard header="net" href="net">
    <p>一个轻量级的 IPv4/IPv6 操作库。</p>
  </DocsCard>
  <DocsCard header="regex" href="regex">
    <p>提供了常用的正则表达式函数。</p>
  </DocsCard>
  <DocsCard header="units" href="units">
    <p>提供了一些数字和国际标准单位之间的转换函数。</p>
  </DocsCard>
  <DocsCard header="yaml" href="yaml">
    <p>提供了与 YAML 相关的编码/解码函数。</p>
  </DocsCard>
</DocsCards>
