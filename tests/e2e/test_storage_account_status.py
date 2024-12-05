# Test to check if the Azure Storage Account exists and is configured correctly
def test_storage_account_status(storage_client, terraform_variables):
    # Use the variables parsed from variables.tf
    resource_group = terraform_variables['variable'][1]['resource_group_name']['default']
    storage_account_name = terraform_variables['variable'][5]['storage_account_name']['default']
    
    # Get the Storage Account details
    storage_account = storage_client.storage_accounts.get_properties(resource_group, storage_account_name)

    # Assert that the Storage Account exists
    assert storage_account is not None, f"Storage Account {storage_account_name} does not exist."
    
    # Assert the provisioning state is Succeeded of the Storage Account
    assert storage_account.provisioning_state == 'Succeeded', \
        f"Storage Account {storage_account_name} is not provisioned correctly. " \
        f"Provisioning state: {storage_account.provisioning_state}"

    # Assert that the account kind of the Storage Account is StorageV2
    assert storage_account.kind == 'StorageV2', \
        f"Storage Account {storage_account_name} is not of the expected 'StorageV2' kind, found: {storage_account.kind}"

    # Assert the replication type (Locally Redundant Storage)
    expected_replication_type = "LRS"
    assert storage_account.sku.name.endswith(expected_replication_type), \
        f"Storage Account {storage_account_name} replication type is not {expected_replication_type}, " \
        f"found: {storage_account.sku.name}"
        
    # Assert the location of the Storage Account
    expected_location = terraform_variables['variable'][0]['azure_region']['default'].replace(" ", "").lower()
    assert storage_account.location.lower() == expected_location.lower(), \
        f"Storage Account {storage_account_name} is not in the expected location. " \
        f"Expected: {expected_location}, Found: {storage_account.location}"