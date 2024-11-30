import pytest
import json
from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.network import NetworkManagementClient
import hcl2
import os

# Set the Azure subscription ID (can be set in environment variables or config.json)
# os.environ['AZURE_SUBSCRIPTION_ID'] = 'xxxxxxxx'

# Fixture to retrieve Azure subscription ID from the config.json file
@pytest.fixture(scope="session")
def azure_subscription_id():
    # Determine the path to the config.json file
    config_file_path = os.path.join(os.path.dirname(__file__), '..', 'config.json')
    
    if not os.path.exists(config_file_path):
        raise FileNotFoundError(f"Configuration file {config_file_path} not found.")
    
    # Read the config.json file and extract the Azure subscription ID
    with open(config_file_path, 'r') as file:
        config = json.load(file)
        subscription_id = config.get('azure_subscription_id')
        
        if not subscription_id:
            raise ValueError("Azure subscription ID not found in configuration file.")
        
    return subscription_id


@pytest.fixture(scope="session")
def compute_client(azure_subscription_id):
    """Fixture to create and provide a ComputeManagementClient."""
    credential = DefaultAzureCredential()
    client = ComputeManagementClient(credential, azure_subscription_id)
    return client


@pytest.fixture(scope="session")
def network_client(azure_subscription_id):
    """Fixture to create and provide a NetworkManagementClient."""
    credential = DefaultAzureCredential()
    client = NetworkManagementClient(credential, azure_subscription_id)
    return client

# Fixture to load and parse the Terraform variables from variables.tf
@pytest.fixture(scope="session")
def terraform_variables():
    # Path to your variables.tf file
    project_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    tfvars_file = os.path.join(project_dir, 'variables.tf')

    # Read and parse the .tf file
    with open(tfvars_file, 'r') as file:
        terraform_vars = hcl2.load(file)
    
    # Return the parsed Terraform variables as a dictionary
    return terraform_vars