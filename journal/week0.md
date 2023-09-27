
# Terraform Beginner Bootcamp 2023 - Week 0

## NOTE: Always review your files before you commit them! Be sure that sensitive information is removed. Such as AWS secret keys etc.

- [Terraform Beginner Bootcamp 2023 - Week 0](#terraform-beginner-bootcamp-2023---week-0)
  * [NOTE: Always review your files before you commit them! Be sure that sensitive information is removed. Such as AWS secret keys etc.](#note--always-review-your-files-before-you-commit-them--be-sure-that-sensitive-information-is-removed-such-as-aws-secret-keys-etc)
  * [Semantic Versioning](#semantic-versioning)
  * [Install Terraform CLI](#install-terraform-cli)
    + [Consideraton with the Terraform CLI changes](#consideraton-with-the-terraform-cli-changes)
    + [Considerations for Linux Distributions](#considerations-for-linux-distributions)
    + [Refactoring into Bash scripts](#refactoring-into-bash-scripts)
      - [Shebang Considerations](#shebang-considerations)
      - [Execution Considerations](#execution-considerations)
      - [Linux Permissions Considerations](#linux-permissions-considerations)
    + [GitPod Lifecycle (Before, Init, Command)](#gitpod-lifecycle--before--init--command-)
    + [Working With Env Vars](#working-with-env-vars)
      - [env command](#env-command)
      - [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
      - [Printing Env Vars](#printing-env-vars)
      - [Scoping of Env Vars](#scoping-of-env-vars)
      - [Persisting Env Vars in GitPod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
    + [We'll need to generate AWS CLI credits from IAM User in order to the user AWS CLI.](#we-ll-need-to-generate-aws-cli-credits-from-iam-user-in-order-to-the-user-aws-cli)
    + [AWS CLI Installation](#aws-cli-installation-1)
  * [Terraform Basics](#terraform-basics)
    + [Terraform Registry](#terraform-registry)
    + [Terraform Console](#terrafomr-console)
      - [Terraform init](#terraform-init)
      - [Terraform plan](#terraform-plan)
      - [Terraform apply](#terraform-apply)
      - [Terraform Destroy](#terraform-destroy)
      - [Terraform Lock Files](#terraform-lock-files)
      - [Terraform State FIles](#terraform-state-files)
      - [Terraform Directory](#terraform-directory)
  * [AWS S3 Bucket](#aws-s3-bucket)
  * [Issues with Terraform Cloud Login and GitPod Workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)
  * [Terraform Alias](#terraform-alias)

## Semantic Versioning

This project is going to utilize semantic versioning for its tagging.

[semver.org](https://semver.org/)

The general format: ***MAJOR.MINOR.PATCH***, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install Terraform CLI

### Consideraton with the Terraform CLI changes
The Terraform installation instuctions have changed due to gpg keyring changes. So the latest cli 
install instructions needed to be referenced via the Terrafrom documentaion to make the necessary 
updates to the bash scripting code for an automated install without user input. 

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distributions

This project is built on Ubuntu. Please check your Linux distribution and change accordingly to 
distribution needs.

[How to check OS version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS version
```
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

## Refactoring into Bash scripts 

While fixing the Terraform gpg deprecated issue, a new Terraform Bash script file ("install_terraform_cli") was created. 
Because this new Bash script file has considerably more code, it was decided to make it executable and add it as a  
task in the .gitpod.yml file. 

This Bash script is located here: [./bin/install_installation_cli](./bin/install_terraform_cli)

- This will keep the GitPod task file ([.gitpod.yml](.gitpod.yml)) orderly and clean.
- This allows easier debugging.
- An automated install of Terraform CLI.
- This makes portability easier for other project that require the installation of Terraform CLI.


#### Shebang Considerations

A Shebang (pronounced Sha-bang) tells the Bash script what program will interpret the script. eg. `#!/bin/bash`

ChatGPT recommended this format for Bash: `#!/usr/bin/env bash`

- For portability on different OS distributions
- Will search the user's PATH for the bash executable

#### Execution Considerations
When executing the bash script we can use the `./.` shorthand notation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.

eg. `source ./bin/install_terraform_cli`

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Linux Permissions Considerations 

In order to make our bash scripts executable, we need to change Linus permissions for the file 
to be executable at the user class level.

```sh
chmod u+x ./bin/install_terraform_cli
```
Alternatively 


```sh
chmod 744 ./bin/install_terraform_cli
```

https://en.wikipedia.org/wiki/Chmod

### GitPod Lifecycle (Before, Init, Command)

We need to be careful when using init because it will NOT refrun if we restart an existing GitPod workspace.

https://www.gitpod.io/docs/configure/workspaces/tasks

### Working With Env Vars

#### env command

We can list all Environment Variables (En Vars) using the `env` command 

We can filter for specific env vars by using `grep` eg. `env | grep AWS_`

### Setting and Unsetting Env Vars

In the terminal, as an example, we can set an env var with `export VATO='loco'`

In the terminal, as an example, we can unset an env var with `unset VATO`

We can set an env var temporarily when runnng a command. eg. 

```sh
VATO='loco' ./bin/print_message
```
Within a bash script we can set an en var without writing export eg. 

```sh
#!/usr/bin/env bash

VATO='loco'

echo $VATO
```

#### Printing Env Vars

We can print an env var using `echo` eg. `echo $VATO`

### Scoping of Env Vars

When new bash terminals are opened in VS-Code, it will not be aware of env vars that have ben set in another bash terminal window. 

For env vars to persist accross all future bash terminals that are open, you need to set env vars in your bash profile.

#### Persisting Env Vars in GitPod

env vars can be set as persistent in GitPod by storing them in GitPods Secret Storage.

```
gp env VATO='loco'
```

All future workspaces that are launched, will set the env vars for all bash terminal windows opened in those workspaces.

You can also set enve vars in the `.gitpod.yml` fie but this can only contain non-sensitive env vars.


# AWS CLI Installation
AWS CLI is installed for the project via the bash script [./bin/install_aws_cli](https://github.com/ultraman-labs/terraform-beginner-bootcamp-2023/blob/7-refactor-aws-cli-script/bin/install_aws_cli)

[Getting Started Installing (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) [AWS CLI Env Var](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials is configured correctly by running the following AWS CLI command:

```bash
$ aws sts get-caller-identity
```
If it is succesful you should see a json payload return that looks like this:

```json
{
    "UserId": "VIEARGUO784YVHJ5WIJ5KZ",
    "Account": "0123456789012",
    "Arn": "arn:aws:iam::123456789012:user/Mocos"
}
```
### We'll need to generate AWS CLI credits from IAM User in order to the user AWS CLI.

### AWS CLI Installation 

AWS CLI is installed via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials are configured correctly by running the following AWS CLI command:

```sh
aws sts get-caller-identity
```
If it's successful, you should see a json payload that looks like this:

```json
{
    "UserId": "AIDA4XSIEY5LE4JT6ABC12",
    "Account": "0123456789012",
    "Arn": "arn:aws:iam::0123456789012:user/Mocos"
}
```
We'll need to generate AWS CLI credentials from IAM user in order to use the AWS CLI

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry which is located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** is an interface to APIs that will allow to create resources in Terraform. 
- **Modules** are a way to make large amount of Terraform code modular, portable, and sharable. 
[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

### Terrafomr Console

We can see a list of all the Terraform commands by simply typing `terraform`

#### Terraform init

At the start of a new Terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project. 

#### Terraform plan

This will generate out a changeset, about the state of our infrastructure and what changes will take place.

We can output this changeset ie. "plan" to be passed to an apply command, but often you can just ignore outputting.

#### Terraform apply

`terraform apply`

This will run a plan and pass the changeset to be executed by Terraform-- apply will prompt the user with "yes" or "no" to decide on continuing with executing the command. 

If we want to automatically approve an apply we can do this by using the auto approve flag. eg. `terraform apply --auto-approve`

#### Terraform Destroy

This command will to tear down and delete the infrastructure resources that you've created and managed using Terraform.

To not have the prompt invoked, `$ terraform destroy --auto-approve` can be used.

#### Terraform Lock Files

`terraform.lock.hcl`contains the locked versioning for the 
 providers or modules that should be used with this project.

The Terraform Lock File **should be committed** to your Version Control System (VCS) eg. GitHub

#### Terraform State FIles

`terraform.tfstate` contains information about the current state of your infrastructure.

This file **should not be committed.** to your VCS.

This file can contain sensitive data. If you lose this file, you lose knowing the state of your infrustructure.

`terraform.tfstate.backup` is the previous state (all settings) of the file state. 

#### Terraform Directory

`.terraform` directory contains binaries of Terraform providers.

## AWS S3 Bucket

Discoverd that code in the main.tf file was generating an S3 bucket name that contained upper case letters. This 
did not conform to the AWS bucket naming rules-- and raised an error when running `terraform apply`. So the remedy
was to add and set the "upper" flag as `upper = false`. Also to decrease the chances of having the same bucket name
with another bucket in the world, the length of the name was icreased from 16 to 32 characters.

## Issues with Terraform Cloud Login and GitPod Workspace

When attempting to run `erraform login` it wlll launch in bash wisiwig view to generate a token. However, it does not
work as expected in GitPod VS-Code in the browser.

The workaround is to manually generate a token in Terraform CLoud 

```
https://app.terraform.io/app/settings/tokens
```

Then create open the file manualy here:

```sh
$ touch /home/gitpod/.terraform.d/credentials.tfrc.json
$ open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace your token in the file)

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```
We automated the workaround with this bash script [bin/generate_tfrc_credentials](https://github.com/ultraman-labs/terraform-beginner-bootcamp-2023/blob/15-generate-tfrc/bin/generate_tfrc_credentials)


## Terraform Alias

To be effecient and true Terraformers we are setting an alias (a short cut for frequently used commands) that will allows us to enter        `$ tf`instead of `$ terraform` so that we don't have to type the entire word. This is done in the `.bash_profile` file that configures the terminal's command-line environment.


