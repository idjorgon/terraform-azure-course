## Description

This is a POC for IaC testing. It uses Terraform to create and deploy a few different Azure resources like resource group and virtual machine. The tests are written in Python/pytest and use the Azure Python SDK to verify the resources are created as expected. There are also Pester unit tests included as well as a couple of tests utilizing the Terraform Test framework.

Tests are located in the `tests` directory/folder. The `tests/e2e` folder contains sample tests that leverage Azure SDK management libraries and pytest. The `tests/unit` folder contains "unit tests" that are based on the Pester framework (a couple of tests are included that are based on the Terraform Test framework.)


## Prerequisites

1. Download and install [Visual Studio Code](https://code.visualstudio.com/download)
2. You will need a Microsoft Azure subscription
3. Install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
4. Install latest version of [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
5. Install Python
6. Install PowerShell
7. Install what's outlined in `requirements.txt` file: pytest, azure management libraries, json


## Azure Setup

There are a couple of different ways you can authenticate and sign in to Azure. I used the following method to sign in and set the proper subscription:

1. Run the `az login` command and proceed to sign in with your account credentials in the browser
2. After you sign in, CLI commands are run against your default subscription; if you have multiple subscriptions, you can change your default subscription using `az account set --subscription`

Read more about signing in to Azure [here](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli), and managing subscriptions [here](https://learn.microsoft.com/en-us/cli/azure/manage-azure-subscriptions-azure-cli)


## Run Python/pytest tests

- `pytest -v -s tests/`


## Running sample Pester unit tests

- Preconditions:
    - Create tf_plan folder in the root directory of the repo
    - Create/have a terraform plan file that you can save
    - Type `terraform plan -out tf_plan/terraform.plan` in the terminal to create and save the plan file
    - Type `terraform show -json terraform.plan` to ensure that the file is created and you are able to view it in JSON format
    - Use this plan file to compare and test the resources

- Type `./tests/unit/unit.tests.ps1` in PowerShell terminal from the main/root directory of the repo


## Running sample unit tests using the Terraform Test Framework

- Type `terraform test` in the terminal (this will run and execute the terraform tests)


## A few fundamental Terraform workflow commands

- `terraform fmt`
- `terraform plan`
- `terraform apply -auto-approve`
- `terraform apply -destroy`
- `terraform state list`