---
sidebar_position: 5
---
# Docgen

The KCL Docgen tool supports extracting model documents from KCL source code and supports multiple output formats: JSON, YAML and Markdown. This article introduces the document specification of the KCL language, gives an example of how to use the KCL Docgen tool to extract documents, and shows the process of importing localization documents.

## 1. Document Specification of KCL

The documentation of the KCL file mainly contains the following two parts:

* Current KCL Module document: description of the current KCL file
* All schema documents contained in the KCL file: a description of the current schema, including schema description, schema attribute descriptions, and Examples. The specific format is as follows:

1. Schema description

  ```python
  """This is a brief description of the Schema
  """
  ```

2. Description of each attribute of Schema: including attribute description, attribute type, default value, optional or required

  ```python
  """
  Attributes
  ----------
  x : type, default is a, optional.
      Description of parameter `x`.
  y : type, default is b, required.
      Description of parameter `y`.
  """
  ```

  `----------` indicates that `Attributes` is a title (the length of the symbol `-` is the same as the length of the title), the attribute name and attribute type are separated by a colon `:`, the description of the attribute is written on another line with indentation. The default value of the attribute is separated by a comma `,` after the attribute type, and it is written in the form of `default is {default value}`. In addition, it is necessary to indicate whether the attribute is optional/required. Write `optional` after the default value for an optional attribute, and write `required` after the default value for a required attribute.

3. Examples

  ```python
  """
  Examples
  --------
  val = Schema {
      name = "Alice"
      age = 18
  }
  """
  ```

In addition, the KCL docstring syntax should use a subset of the [re-structured text (reST)](https://docutils.sourceforge.io/rst.html) and be rendered using the [Sphinx](https://www.sphinx-doc.org/en/master/).

## 2. Generating Documentation From KCL

Use the `kcl-doc generate` command to extract documentation from a user-specified file or directory and output it to the specified directory.

1. Args

  ```
  usage: kcl-doc generate [-h] [--format YAML] [-o OUTPUT] [--r]
                          [--i18n-locale LOCALE] [--repo-url REPO_URL]
                          [files [files ...]]

  positional arguments:
    files                 KCL file paths. If there's more than one files to
                          generate, separate them by space

  optional arguments:
    -h, --help            show this help message and exit
    --format YAML         Doc file format, support YAML, JSON and MARKDOWN.
                          Defaults to MARKDOWN
    -o OUTPUT, --output-path OUTPUT
                          Specify the output directory. Defaults to ./kcl_doc
    --r, -R, --recursive  Search directory recursively
    --i18n-locale LOCALE  I18n locale, e.g.: zh, zh_cn, en, en_AS. Defaults to
                          en
    --repo-url REPO_URL   The source code repository url. It will be displayed in
                          the generated doc to link to the source code.
  ```

2. Extract documents from the file(s) and output them to the specified directory

  ```text
  kcl-doc generate your_config.k your_another_config.k -o your_docs_output_dir
  ```

3. From the specified directory, recursively find the KCL file(s) and extract the documentation

  ```text
  kcl-doc generate your_config_dir -r -o your_docs_output_dir
  ```

4. When generating documentation, specify the source code repository address. The generated documentation will contain links to source files

  ```text
  kcl-doc generate your_config.k -o your_docs_output_dir --repo-url https://url/to/source_code
  ```

## 3. Add Documentation for Localized Languages

As shown before, by default, the documentation extracted by the documentation generation tool is based on the content of the source docstring, and thus the language of the documentation depends on the language in which the docstring was written. If you need to add localized language documentation to the source file, you can follow the steps below:

1. Initialize the i18n configuration file. This step generates the corresponding i18n configuration file based on the specified KCL file. The file format can be JSON/YAML, and the default is YAML. The output profile name will end in the specified target localization language

  ```text
  kcl-doc init-i18n your_config.k --format JSON --i18n-locale your_target_locale
  ```

2. Modify the i18n configuration file and update each doc field in your locale language

3. Generate localized documents from the modified i18n configuration file

  ```text
  kcl-doc generate your_config_dir --i18n-locale your_target_locale --format Markdown
  ```

  Next, a simple example is used to demonstrate the process of adding localized language documents.

  3.1 Prepare the KCL file, such as `server.k`:

    ```python
    schema Server:
        """Server is the common user interface for long-running
        services adopting the best practice of Kubernetes.

        Attributes
        ----------
        workloadType : str, default is "Deployment", required
            Use this attribute to specify which kind of long-running service you want.
            Valid values: Deployment, CafeDeployment.
            See also: kusion_models/core/v1/workload_metadata.k.
        name : str, required
            A Server-level attribute.
            The name of the long-running service.
            See also: kusion_models/core/v1/metadata.k.
        labels : {str:str}, optional
            A Server-level attribute.
            The labels of the long-running service.
            See also: kusion_models/core/v1/metadata.k.

        Examples
        ----------------------
        myCustomApp = AppConfiguration {
            name = "componentName"
        }
        """

        workloadType: str = "Deployment"
        name: str
        labels?: {str: str}
    ```

  3.2 Get the initialized i18n configuration file from the `server.k`. For example, if you want to add Chinese documents to it, specify the format of the generated configuration file as YAML

    ```text
    kcl-doc init-i18n server.k --format YAML --i18n-locale zh_cn
    ```

    This command will create the directory `kcl_doc` under the current directory and generate the i18n configuration file `kcl_doc/i18n_server_zh_cn.yaml`. Its contents are as follows:

    ```yaml
    name: server
    relative_path: ./server.k
    schemas:
    - name: Server
      doc: |
        Server is the common user interface for long-running
        services adopting the best practice of Kubernetes.
      attributes:
      - name: workloadType
        doc: |
          Use this attribute to specify which kind of long-running service you want.
          Valid values: Deployment, CafeDeployment.
          See also: kusion_models/core/v1/workload_metadata.k.
        type:
          type_str: str
          type_category: BUILTIN
          builtin_type: STRING
        default_value: '"Deployment"'
        is_optional: false
      - name: name
        doc: |
          A Server-level attribute.
          The name of the long-running service.
          See also: kusion_models/core/v1/metadata.k.
        type:
          type_str: str
          type_category: BUILTIN
          builtin_type: STRING
        is_optional: false
        default_value: ''
      - name: labels
        doc: |
          A Server-level attribute.
          The labels of the long-running service.
          See also: kusion_models/core/v1/metadata.k.
        type:
          type_str: '{str: str}'
          type_category: DICT
          dict_type:
            key_type:
              type_str: str
              type_category: BUILTIN
              builtin_type: STRING
            value_type:
              type_str: str
              type_category: BUILTIN
              builtin_type: STRING
        is_optional: true
        default_value: ''
      examples: |
        myCustomApp = AppConfiguration {
            name = "componentName"
        }
    doc: ''
    source_code_url: ''
    ```

  3.3 Modify all the `doc` fields to the Chinese description. The modified configuration is as follows:

    ```yaml
    name: server
    relative_path: ./server.k
    schemas:
    - name: Server
      doc: |
        Server 模型定义了采用 Kubernetes 最佳实践的持续运行的服务的通用配置接口
      attributes:
      - name: workloadType
        doc: |
          workloadType 属性定义了服务的类型，是服务级别的属性。合法的取值有：Deployment, CafeDeployment.
          另请查看：kusion_models/core/v1/workload_metadata.k.
        type:
          type_str: str
          type_category: BUILTIN
          builtin_type: STRING
        default_value: '"Deployment"'
        is_optional: false
      - name: name
        doc: |
          name 为服务的名称，是服务级别的属性。
          另请查看：kusion_models/core/v1/metadata.k.
        type:
          type_str: str
          type_category: BUILTIN
          builtin_type: STRING
        is_optional: false
        default_value: ''
      - name: labels
        doc: |
          labels 为服务的标签，是服务级别的属性。
          另请查看：kusion_models/core/v1/metadata.k.
        type:
          type_str: '{str: str}'
          type_category: DICT
          dict_type:
            key_type:
              type_str: str
              type_category: BUILTIN
              builtin_type: STRING
            value_type:
              type_str: str
              type_category: BUILTIN
              builtin_type: STRING
        is_optional: true
        default_value: ''
      examples: |
        myCustomApp = AppConfiguration {
            name = "componentName"
        }
    doc: ''
    source_code_url: ''
    ```

  3.4 Based on the modified i18n configuration, generate documents in localized languages. Execute the following command to output the Chinese document `kcl_doc/doc_server_zh_cn.md`. The commands and the contents of the generated documents are as follows:

  ```text
  kcl-doc generate server.k --i18n-locale zh_cn --format Markdown
  ```

  ~~~markdown
  # server
  ## Schema Server
  Server 模型定义了采用 Kubernetes 最佳实践的持续运行的服务的通用配置接口

  ### Attributes
  |Name and Description|Type|Default Value|Required|
  |--------------------|----|-------------|--------|
  |**workloadType**<br />workloadType 属性定义了服务的类型，是服务级别的属性。合法的取值有：Deployment, CafeDeployment.<br />另请查看：kusion_models/core/v1/workload_metadata.k.|str|"Deployment"|**required**|
  |**name**<br />name 为服务的名称，是服务级别的属性。<br />另请查看：kusion_models/core/v1/metadata.k.|str|Undefined|**required**|
  |**labels**<br />labels 为服务的标签，是服务级别的属性。<br />另请查看：kusion_models/core/v1/metadata.k.|{str: str}|Undefined|optional|
  ### Examples
  ```
  myCustomApp = AppConfiguration {
      name = "componentName"
  }
  ```

  <!-- Auto generated by kcl-doc tool, please do not edit. -->
  ~~~

## 4. Appendix

### 1. Concept of reST

For documents in reST format, paragraphs and indentation are important, new paragraphs are marked with blank lines, and indentation is the indentation indicated in the output. Font styles can be expressed as follows:

* \*Italic\*
* \*\*Bold\*\*
* \`\`Monospaced\`\`

Refer to [reST](https://docutils.sourceforge.io/rst.html) for more information.
