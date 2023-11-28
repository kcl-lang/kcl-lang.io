---
slug: 2023-08-23-biweekly-newsletter
title: KCL Biweekly Newsletter (2023 08.10 - 08.23) | KCL v0.5.3, v0.5.4 and v0.5.5 are out!
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Biweekly-Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter.png)

[KCL](https://github.com/kcl-lang) is an open-source, constraint-based record and functional language that enhances the writing of complex configurations, including those for cloud-native scenarios. With its advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

This section will update the KCL language community's latest developments every two weeks, including features, website updates, and the latest community news, helping everyone better understand the KCL community!

**_KCL Website: [https://kcl-lang.io](https://kcl-lang.io)_**

## Overview

Thank you to all contributors for their outstanding work over the past two weeks (08.10-08.23 2023). Here is an overview of the key content:

**🔧 Language and Toolchain Updates**

- **KCL Formatting Tool Updates** - Support for formatting code snippets with syntax errors and partial code snippets and automatic correction of indentation errors in configuration blocks.
- **KCL Documentation Tool Updates** - Support for exporting document index pages
- **KCL Import Tool Updates** - Support for converting Terraform Provider Schema to KCL Schema
- **KCL Export Tool Updates** - Support for exporting OpenAPI Spec from KCL Schema, integrating with OpenAPI ecosystem
- **KCL IDE Updates** - Support for compilation cache feature to improve performance of some IDE features and providing rich error messages and import statement quick fix capabilities
- **KCL Package Management Tool Updates** - Support for output information experience optimization for the `kpm push` command and adding duplicate tag check when pushing KCL package. Adding the `--vendor` parameter for the `kpm push` and `kpm pkg` commands to determine whether to package third-party libraries in KCL packages together
- **KCL Language Updates** - Optimize Schema semantic check and union type check error messages and support for exporting type output of configuration blocks.

🏄 **API Updates**

- KCL Schema model parsing GetSchemaType API newly added KCL package related information and schema attribute default values.

**📰 Official Website and Use Case Updates**

- KCL package docker.io integration example: _[https://github.com/kcl-lang/kpm/blob/main/docs/publish_to_docker_reg.md](https://github.com/kcl-lang/kpm/blob/main/docs/publish_to_docker_reg.md)_
- KCL Gitlab CI integration example: _[https://kcl-lang.io/docs/user_docs/guides/ci-integration/gitlab-ci](https://kcl-lang.io/docs/user_docs/guides/ci-integration/gitlab-ci)_
- KCL Vault and Vals Integration example: _[https://kcl-lang.io/docs/user_docs/guides/secret-management/vault](https://kcl-lang.io/docs/user_docs/guides/secret-management/vault)_

## Special Thanks

The following are listed in no particular order:

- Thanks to @jakezhu9 for the contribution of the KCL Import Tool Terraform Schema to KCL Schema conversion 🙌 [https://github.com/kcl-lang/kcl-go/pull/141](https://github.com/kcl-lang/kcl-go/pull/141)
- Thanks to @xxmao123 and @starkers for the discussion and contribution of the NeoVim KCL extension 🙌 [https://github.com/kcl-lang/vim-kcl/pull/2](https://github.com/kcl-lang/vim-kcl/pull/2)
- Thanks to @starkers for adding KCL installation support to the mason.nvim registry 🙌 [https://github.com/mason-org/mason-registry/pull/2425](https://github.com/mason-org/mason-registry/pull/2425)
- Thanks to @prahaladramji for upgrading and updating the KCL Homebrew installation script 🙌 [https://github.com/kcl-lang/homebrew-tap/pull/1](https://github.com/kcl-lang/homebrew-tap/pull/1)
- Thanks to @yamin-oanda for the discussion of Pulumi's official KCL support 🙌 [https://github.com/pulumi/pulumi/discussions/13722](https://github.com/pulumi/pulumi/discussions/13722)
- In addition, thanks to @nkabir, @mihaigalos, @prahaladramji, @yamin-oanda, @magick93, @MirKml, and others for their valuable feedback and discussions while using KCL in the past two weeks. 🙌

## Featured Updates

### KCL Import Tool Updates

The KCL Import Tool now adds support for converting Terraform Provider Schema to KCL Schema based on Protobuf, JsonSchema OpenAPI models, and Go Structures, such as the following Terraform Provider Json (obtained through the command `terraform providers schema -json > provider.json` , For more details, please refer to [https://developer.hashicorp.com/terraform/cli/commands/providers/schema](https://developer.hashicorp.com/terraform/cli/commands/providers/schema))

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
                "type": ["set", "string"],
                "description_kind": "plain",
                "optional": true,
                "computed": true
              },
              "security_ips": {
                "type": ["set", "string"],
                "description_kind": "plain",
                "optional": true,
                "computed": true
              },
              "tags": {
                "type": ["map", "string"],
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
                "type": ["list", "string"],
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

Then the tool can output the following KCL code

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

### KCL Vault Integration

In just three steps, we can use Vault to store and manage sensitive information and use it in KCL.

Firstly, we install and use `Vault` to store `foo` and `bar` information

```shell
vault kv put secret/foo foo=foo
vault kv put secret/bar bar=bar
```

Then write the following KCL code (main.k)

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

Finally, the decrypted configuration can be obtained through the `Vals` command-line tool

```shell
kcl main.k | vals eval -f -
```

> For more details and use cases, please refer to [https://kcl-lang.io/docs/user_docs/guides/secret-management/vault](https://kcl-lang.io/docs/user_docs/guides/secret-management/vault)

## Community

- 🎉 Congratulations to Zhu Junxing from Huazhong University of Science and Technology for successfully passing the mid-term assessment of the Gitlink Coding Summer Camp (GLCC) and completing the conversion of KCL Import tool Jsonschema and Terraform Provider Schema to KCL Schema. The community will grant him the KCL Community Maintainer role in the future.
- 💻 KCL participated in the CNCF TAG Application Delivery community meeting and reported on the project.

## Resources

❤️ Thanks to all KCL users and community members for their valuable feedback and suggestions in the community. We will write more articles on the new features of KCL v0.5.x, so stay tuned!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)

- [KCL 2023 Roadmap](https://kcl-lang.io/docs/community/release-policy/roadmap)
- [KCL v0.6.0 Milestone](https://github.com/kcl-lang/kcl/milestone/6)
- [KCL Github Issues](https://github.com/kcl-lang/kcl/issues)
- [KCL Github Discussion](https://github.com/orgs/kcl-lang/discussions)
- [KCL Community](https://github.com/kcl-lang/community)
