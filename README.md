# Terraform Beginner Bootcamp 2023

## Semantic Versioning :alien:

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

Example of checkin OS version
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