# Terraform Beginner Bootcamp 2023 - Week 1

Terraform Beginner Bootcamp 2023 - Week 1

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

