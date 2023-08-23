---
slug: 2023-08-23-biweekly-newsletter
title: KCL 社区开源双周报 (2023 08.10 - 08.23) | KCL v0.5.3, v0.5.4 和 v0.5.5 版本发布
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Biweekly-Newsletter]
---

![](/img/biweekly-newsletter-zh.png)

[KCL](https://github.com/kcl-lang) 是一个开源的基于约束的记录及函数语言并通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

本栏目将会双周更新 KCL 语言社区最新动态，包括功能、官网更新和最新的社区动态等，帮助大家更好地了解 KCL 社区！

***KCL 官网：[https://kcl-lang.io](https://kcl-lang.io)***

## 内容概述

感谢所有贡献者过去两周 (2023 08.10 - 08.23) 的杰出工作，以下是重点合并内容概述

- **🔧 语言及工具链更新**
  - KCL 格式化工具更新
    - 支持对有语法错误的代码片段和部分代码片段进行格式化
    - 支持对缩进不对的配置块进行自动校正
  - KCL 文档工具更新
    - 支持导出文档索引页
  - KCL 导入工具更新
    - 支持 Terraform Provider Schema 转换为 KCL Schema
  - KCL 导出工具更新
    - 支持由 KCL Schema 导出 OpenAPI Spec，接入 OpenAPI 生态
  - KCL IDE 更新
    - 支持编译缓存特性，提升部分 IDE 功能性能
    - 丰富 IDE 错误信息，并提供 Import 语句快速修复能力
  - KCL 包管理工具 KPM 更新
    - kpm push 输出信息体验优化，增加推送 KCL 程序包的重复 tag 检查
    - 为 kpm push 和 kpm pkg 增加参数 —vendor 决定是否将 KCL 程序包的三方库打包在一起
  - KCL 语言更新
    - 优化 Schema 语义检查和联合类型检查等错误信息
    - 支持导出配置块的类型输出
- **🏄 API 更新**
  - KCL Schema 模型解析 GetSchemaType API 获取 KCL 包相关信息和 Schema 属性默认值
- **📰 官网和用例更新**
  - 新增通过 docker.io 发布 KCL 包用例: *[https://github.com/kcl-lang/kpm/blob/main/docs/publish_to_docker_reg.md](https://github.com/kcl-lang/kpm/blob/main/docs/publish_to_docker_reg.md)*
  - 新增 KCL Gitlab CI 集成用例: *[https://kcl-lang.io/docs/user_docs/guides/ci-integration/gitlab-ci](https://kcl-lang.io/docs/user_docs/guides/ci-integration/gitlab-ci)*
  - 新增 KCL 密钥管理 Vault 和 Vals 集成用例: *[https://kcl-lang.io/docs/user_docs/guides/secret-management/vault](https://kcl-lang.io/docs/user_docs/guides/secret-management/vault)*

## 特别鸣谢

以下排名不分先后

- 感谢 @jakezhu9 对 KCL Import 工具 Terraform Schema 到 KCL Schema 转换的贡献 🙌 *https://github.com/kcl-lang/kcl-go/pull/141*
- 感谢 @xxmao123 和 @starkers 对 NeoVim KCL 插件的讨论与贡献 🙌 *https://github.com/kcl-lang/vim-kcl/pull/2*
- 感谢 @starkers 对 mason.nvim registry 增加 KCL 的安装支持 🙌 *https://github.com/mason-org/mason-registry/pull/2425*
- 感谢 @prahaladramji 对 KCL Homebrew 安装脚本的升级更新与贡献 🙌 *https://github.com/kcl-lang/homebrew-tap/pull/1*
- 感谢 @yamin-oanda 为 Pulumi 官方提供 KCL 支持的讨论 🙌 *https://github.com/pulumi/pulumi/discussions/13722*
- 此外感谢 @nkabir, @mihaigalos, @prahaladramji, @yamin-oanda, @magick93, @MirKml 等在过去两周使用 KCL 过程中提出的宝贵反馈和讨论 🙌

## 精选更新

### KCL Import 工具更新

KCL Import 工具在 Protobuf, JsonSchema OpenAPI 模型和 Go 结构体转换为 KCL Schema 的基础上，新增 Terraform Provider Schema 到 KCL Schema 的转换支持，比如对于如下的 Terraform Provider Json (通过 `terraform providers schema -json > provider.json` 命令获得，详情请参考 [https://developer.hashicorp.com/terraform/cli/commands/providers/schema](https://developer.hashicorp.com/terraform/cli/commands/providers/schema))

```json
{
    "format_version": "0.2",
    "provider_schemas": {
        "registry.terraform.io/aliyun/alicloud": {
            "provider": {
                "version": 0,
                "block": {
                    "attributes": {},
                    "block_types": {},
                    "description_kind": "plain"
                }
            },
            "resource_schemas": {
                "alicloud_db_instance": {
                    "version": 0,
                    "block": {
                        "attributes": {
                            "db_instance_type": {
                                "type": "string",
                                "description_kind": "plain",
                                "computed": true
                            },
                            "engine": {
                                "type": "string",
                                "description_kind": "plain",
                                "required": true
                            },
                            "security_group_ids": {
                                "type": [
                                    "set",
                                    "string"
                                ],
                                "description_kind": "plain",
                                "optional": true,
                                "computed": true
                            },
                            "security_ips": {
                                "type": [
                                    "set",
                                    "string"
                                ],
                                "description_kind": "plain",
                                "optional": true,
                                "computed": true
                            },
                            "tags": {
                                "type": [
                                    "map",
                                    "string"
                                ],
                                "description_kind": "plain",
                                "optional": true
                            }
                        },
                        "block_types": {},
                        "description_kind": "plain"
                    }
                },
                "alicloud_config_rule": {
                    "version": 0,
                    "block": {
                        "attributes": {
                            "compliance": {
                                "type": [
                                    "list",
                                    [
                                        "object",
                                        {
                                            "compliance_type": "string",
                                            "count": "number"
                                        }
                                    ]
                                ],
                                "description_kind": "plain",
                                "computed": true
                            },
                            "resource_types_scope": {
                                "type": [
                                    "list",
                                    "string"
                                ],
                                "description_kind": "plain",
                                "optional": true,
                                "computed": true
                            }
                        }
                    }
                }
            },
            "data_source_schemas": {}
        }
    }
}
```

经过 KCL Import 工具可以输出为如下 KCL 代码

```python
"""
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""

schema AlicloudConfigRule:
    """
    AlicloudConfigRule

    Attributes
    ----------
    compliance: [ComplianceObject], optional
    resource_types_scope: [str], optional
    """

    compliance?: [ComplianceObject]
    resource_types_scope?: [str]

schema ComplianceObject:
    """
    ComplianceObject

    Attributes
    ----------
    compliance_type: str, optional
    count: int, optional
    """

    compliance_type?: str
    count?: int

schema AlicloudDbInstance:
    """
    AlicloudDbInstance

    Attributes
    ----------
    db_instance_type: str, optional
    engine: str, required
    security_group_ids: [str], optional
    security_ips: [str], optional
    tags: {str:str}, optional
    """

    db_instance_type?: str
    engine: str
    security_group_ids?: [str]
    security_ips?: [str]
    tags?: {str:str}

    check:
        isunique(security_group_ids)
        isunique(security_ips)
```

### KCL Vault 集成

仅需三步，我们就可以使用 Vault 来存储并管理敏感信息并在 KCL 中使用。

首先我们安装并使用 Vault 存储 `foo` 和 `bar` 信息

```shell
vault kv put secret/foo foo=foo
vault kv put secret/bar bar=bar
```

然后编写如下 KCL 代码 (main.k)

```python
apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "nginx"
    labels.app = "nginx"
    annotations: {
        "secret-store": "vault"
        # Valid format:
        #  "ref+vault://PATH/TO/KV_BACKEND#/KEY"
        "foo": "ref+vault://secret/foo#/foo"
        "bar": "ref+vault://secret/bar#/bar"
    }
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
```

最后可以通过 Vals 命令行工具获得解密后的配置

```shell
kcl main.k | vals eval -f -
```

更多详情和用例可以参考 [https://kcl-lang.io/docs/user_docs/guides/secret-management/vault](https://kcl-lang.io/docs/user_docs/guides/secret-management/vault)

## 社区动态

+ 🎉 恭喜来自华中科技大学的朱俊星同学成功通过 Gitlink 编程夏令营 (GLCC) 中期考核并出色地完成了 KCL Import 工具 Jsonschema 和 Terraform Provider Schema 与 KCL Schema 转换的部分，后续社区将为其授予 KCL 社区 Maintainer 角色
+ 💻 KCL 参加 CNCF 云原生计算基金会应用交付 TAG 社区会议并作项目汇报

## 其他资源

❤️ 感谢所有 KCL 用户和社区小伙伴在社区中提出的宝贵反馈与建议。后续我们会撰写更多 KCL v0.5.x 新版本功能解读系列文章，敬请期待!

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)

- [KCL 2023 路线规划](https://kcl-lang.io/docs/community/release-policy/roadmap)
- [KCL v0.6.0 Milestone](https://github.com/kcl-lang/kcl/milestone/6)
- [KCL Github Issues](https://github.com/kcl-lang/kcl/issues)
- [KCL Github Discussion](https://github.com/orgs/kcl-lang/discussions)
- [KCL Community](https://github.com/kcl-lang/community)
