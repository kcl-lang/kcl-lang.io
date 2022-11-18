# From Kubernetes

## 1. Kubernetes OpenAPI Spec

Starting from Kubernetes 1.4, the alpha support for the OpenAPI specification (known as Swagger 2.0 before it was donated to the OpenAPI Initiative) was introduced, and the API descriptions follow the [OpenAPI Spec 2.0](https://github.com/OAI/OpenAPI-Specification/blob/main/versions/2.0.md). And since Kubernetes 1.5, Kubernetes supports [directly extracting models from source code and then generating the OpenAPI spec file](https://github.com/kubernetes/kube-openapi) to automatically keep the specifications and documents up to date with the operation and models.

In addition, Kubernetes CRD uses [OpenAPI V3.0] validation](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/#validation) to describe a custom schema (in addition to the built-in attributes apiVersion, Kind, and metadata), that APIServer uses to validate the CR during the resource creation and update phases.

## 2. KCL OpenAPI Support

The `kcl-openapi` tool supports extracting and generating KCL schemas from Kubernetes OpenAPI/CRD. the [KCL OpenAPI Spec](/docs/tools/cli/openapi/spec) defines the mapping between the OpenAPI specification and the KCL language features.

The `kcl-openapi` tool will be installed by default when installing [Kusion tools pack](/docs/user_docs/getting-started/install). For a quick start with the tool, see [KCL OpenAPI tool](/docs/tools/cli/openapi/)

## 3. Migrate From Kubernetes To KCL

The entirely OpenAPI definition of the Kubernetes built-in model is stored in the [Kubernetes OpenAPI-Spec File](https://github.com/kubernetes/kubernetes/blob/master/api/openapi-spec/swagger.json). Taking this file as input, the KCLOpenapi tool can generate all model schemas of the corresponding version. In the following sections, we will introduce how to migrate from Kubernetes to Kusion with a deployment release scenario as an example. Assume that your project is using [Kubernetes Deployment] (https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) to define Deployment configuration, Migrating to Kusion requires only the following steps:

### 3.1 Write Config Based On The Models

We provide an out-of-the-box `kusion_models` package for you to quickly start. It contains a well-designed frontend model called [`Server schema`](https://github.com/kcl-lang/konfig/blob/main/base/pkg/kusion_models/kube/frontend/server.k). You can declare their configurations by initializing the `Server schema`. For the description and usage of the schema and its attributes, please refer to the [Server schema documentation](https://kcl-lang.io/docs/reference/model/kusion_models/kube/frontend/doc_server).

And as you may have some inventory of Kubernetes configuration data, Kusion plans to provide a `kube2kcl` converting tool to translate them into KCL configuration instances of `Server schema`. This tool is under development.

Once you have configured the model and migrated the data, you can continue your Kusion tour by maintaining and deploying the configurations and you can find guidelines in [Kubernetes - Use Kusion for Application Deployment and maintenance](/docs/user_docs/guides/working-with-k8s/).

### 3.2 Build Your Custom Frontend Models

The existing Kusion Models may not meet your specific business requirements, then you can also design your custom frontend model package. In Konfig's `kusion_kubernetes` directory, there's a copy of the generated Kubernetes 1.22 models and you can design your custom models based on it. And you can also develop your custom scripts to migrate your configuration data as what `kube2kcl` tool does. 

#### 3.2.1 Convert Kubernetes Deployment Into KCL Schema

We already have a copy of [generated Kubernetes 1.22 models](https://github.com/kcl-lang/konfig/blob/main/base/pkg/kusion_kubernetes/api/apps/v1/deployment.k) under the `base/pkg/kusion_kubernetes` directory in the Konfig repository. You can skip this step and use the existing models, or you can generate other versions of that if needed.

Now let's generate a v1.23 version of Kubernetes models. From [Kubernetes v1.23 OpenAPI Spec](https://github.com/kubernetes/kubernetes/blob/release-1.23/api/openapi-spec/swagger.json), we can find the definition of the `apps/v1.Deployment` model, and here is a partial excerpt:

```json
{
    "definitions": {
        "io.k8s.api.apps.v1.Deployment": {
            "description": "Deployment enables declarative updates for Pods and ReplicaSets.",
            "properties": {
                "apiVersion": {
                    "description": "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
                    "type": "string"
                },
                "kind": {
                    "description": "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
                    "type": "string"
                },
                "metadata": {
                    "$ref": "#/definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                    "description": "Standard object's metadata. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata"
                },
                "spec": {
                    "$ref": "#/definitions/io.k8s.api.apps.v1.DeploymentSpec",
                    "description": "Specification of the desired behavior of the Deployment."
                },
                "status": {
                    "$ref": "#/definitions/io.k8s.api.apps.v1.DeploymentStatus",
                    "description": "Most recently observed status of the Deployment."
                }
            },
            "type": "object",
            "x-kubernetes-group-version-kind": [
                {
                    "group": "apps",
                    "kind": "Deployment",
                    "version": "v1"
                }
            ]
        }
    },
    "info": {
        "title": "Kubernetes",
        "version": "unversioned"
    },
    "paths": {},
    "swagger": "2.0"
}
```

You can save the above spec as `deployment.json` and run `kcl-openapi generate model -f deployment.json`, and the KCL Schemas will be generated and output to your current workspace. Other Kubernetes models can also be saved in that spec file and can be generated similarly.

#### 3.2.2 Design Custom Frontend Models

Since the Kubernetes built-in models are atomistic and kind of complex to beginners, we recommend taking the native model of Kubernetes as the backend output model and designing a batch of frontend models which could become a more abstract, friendlier and simpler interface to the user. You can refer to the design pattern in the [`Server Schema in the Konfig repo`](https://github.com/kcl-lang/konfig/blob/main/base/pkg/kusion_models/kube/frontend/server.k).

#### 3.2.3 Migrate The Configuration Data


You can develop your custom scripts to migrate your configuration data automatically. Kusion will later provide writing scaffolding and writing guidelines for this script.

## 4. Migrate From Kubernetes CRD

If you developed CRDs, you can generate the KCL version of the CRD schemas and declare CRs based on that.

* Generate KCL Schema from CRD

    ```
    kcl-openapi generate model --crd --skip-validation -f <your_crd.yaml>
    ```

* Define CR based on CRDs in KCL

    You can initialize the CRD schema to define a CR, or further, you can use the generated schema as a backend model and design a frontend interface for users to initialize. The practice is similar to what `Kusion Models` does on Kubernetes built-in models.
