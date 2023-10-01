# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing Tags

[How to Delete Locale and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locally delete a tag
```bash
 git tag -d <tag_name>
```

Remotely delete a tag
```
git push --delete origin tagname
``

Checkout the commit that you want to retag. Grab the sha from your GitHub history.

```sh
git checkout <SHA>
git tag M.M.P  (Major.Minor.Patch)
git push --tags
git checkout main
```

## Root Module Structure

Our root structure module is as follows:

```
PROJECT_ROOT
|
├── main.tf             # Core configuration file. Used to define and manage your infrastructure as code
├── variables.tf        # stores the structure of input variables
├── terraform.tfvars    # the data of variables we want to load into our Terraform project
├── providers.tf        # defines required providers and their configurations
├── output.tf           # stores our outputs
└── README.md           # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)


## Terraform and Input Variables 
### Terraform Cloud Variables

In Terraform we can set two kinds of variables:
- Environment Variables - those you would set in your bash terminal. eg. AWS credentials
- Terraform Variables - those you would normally set in your tfvars file

We can set Terraform cloud variables to be sensitive so that they are not visibley shown in the UI.

### Loading Terraform Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
We can use the `-var` flag to set an input variable or overide a variable in the tfvars file. 
eg. `$ terraform -var user-uuid="my_user-uuid"`


## terraform tfvars 

This is the default file to load variables in bulk. 

### auto.tfvars

In Terraform, auto.tfvars is a special filename that Terraform automatically loads when you run commands like terraform apply or terraform plan. This file is used to provide default values for input variables defined in your Terraform configuration.

### order of operation of terraform variables

In Terraform, variable values are determined following a specific order of operation:

**Variable Declarations:** Variables are initially defined in the variable block within your Terraform configuration files. These declarations specify the variable name, type, and optional default value.

**Variable Overrides:** Variable values can be overridden using various methods, including command-line flags (-var), variable files (-var-file), environment variables (TF_VAR_variable_name), and interactive input. These methods allow users to customize variable values.

**HCL Configuration:** If a variable is not explicitly overridden using the methods mentioned above, Terraform will use the default value specified in the variable block within the configuration files.

**Variable Defaults:** If no default value is provided in the variable block and the variable is not overridden through any other means, Terraform considers the variable as undefined. In such cases, Terraform may prompt users for the value during execution or raise an error for required variables.

This order of operation allows Terraform to handle variables flexibly, accommodating different scenarios and environments by providing default values and allowing users to customize them as needed.

## Dealing With Configuration Drift

## What happens if we lose our state file?

If you lose your state file, you most likely have to tear down all your cloud infrustructure manually. 

You can use terraform import, but it won't work for all terraform clous resources. You need to check the terraform providers documentation for which resources support import.


### Fix Missing Resources With Terraform Input

`terraform import aws_s3_bucket.example`

[Terraform Imort](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string#import)

### Fix Manual Configuration

If via ClickOps a cloud resource is manually deleted or modified.

If we run terraform again it will attempt to put our infrustructure back into the expected state fixing Configuration Drift.


## Fix using Terraform Refresh

```tf
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommended to place `modules` in a directory when locally
developing modules but you can name it whatevery you prefer.
### Passing input variables

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

Using the sour we can import the module (file) from many different source types. Such as:
- locally, i.e, local path
- GitHub
- Terraform Registry
- S3 Buckets
- HTTPS URLs


We can pass input variables to our module 
The module has to declare the terraform variables in its own 
variable tf.
```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```

[Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources#s3-bucket)

## NOTE: Terraform Init Plan
If in the file hierarchy, the top level variable.tf file is empty, and even if there's a hierarchical lower level variable.tf file, defined with module key-values, running `terraform plan` will raise an error. Saying that there are referencing input variables that are undeclared. So there are two options:

- 1) Declare the input variables in the top level variables.tf 
     file.
- 2) Delete the top level variable.tf file. The 'terraform plan'
     command will then, in its initialization, find the lower variable.tf file and no raised error of an undeclared variable will be raised.      

## Copnsiderations when using ChatGPT to write Terraform

LLMs, such as ChatGPT, may not be trained on the latest documentation or informaiton about Terraform.

It may likely produce older examples that could be deprecated. Often affecting providers.

## Working With Files in Terraform

### Fileexist function

This is a built in Terraform function to check the existance of a file.

```tf
    condition     = fileexists(var.error_html_filepath)
```
[Fileexists Reference](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### Filemd5

[Filemd5 Reference](https://developer.hashicorp.com/terraform/language/functions/filemd5)

## Path Variable

In Terraform there is a special variable called `path`` that allows to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module 

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```tf
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = ${root.path}/public/index.html

  etag = filemd5(var.index_html_filepath)
}
```
## Terraform Locals

Locals allows us to define local variables.
It can be very useful when we need to transform data into another format, and have it referenced as another variable.
```tf
locals {
    s3_origin_id = "MyS3Orgin"
}
```
[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform Data Sources

This allows us to source data from clous resources.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

We use the jsonencode to create the JSON policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)