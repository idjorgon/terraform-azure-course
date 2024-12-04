## Description

This is a POC for IaC testing, for ADM.


## Prerequisites

1. Download and install [Visual Studio Code](https://code.visualstudio.com/download)
2. You will need a Microsoft Azure subscription
3. Install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
4. Install latest version of [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
5. Install Python
6. Install what's outlined in `requirements.txt` file: pytest, azure management libraries, json


## Azure Setup

There are a couple of different ways you can authenticate and sign in to Azure. I used the following method to sign in and set the proper subscription:

1. Run the `az login` command and proceed to sign in with your account credentials in the browser
2. After you sign in, CLI commands are run against your default subscription; if you have multiple subscriptions, you can change your default subscription using `az account set --subscription`

Read more about signing in to Azure [here](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli), and managing subscriptions [here](https://learn.microsoft.com/en-us/cli/azure/manage-azure-subscriptions-azure-cli)


## Run Python/pytest tests

- `pytest -v -s tests/`


## Fundamental Terraform workflow & commands

- `terraform fmt`
- `terraform plan`
- `terraform apply -auto-approve`
- `terraform apply -destroy`
- `terraform state list`