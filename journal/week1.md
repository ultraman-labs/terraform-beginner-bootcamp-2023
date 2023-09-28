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
