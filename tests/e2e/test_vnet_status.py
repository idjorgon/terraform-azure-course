# Test to check if the Azure Virtual Network (VNet) provisioning state is "Succeeded"
def test_vnet_status(network_client, terraform_variables):
    #resource_group = "mtc-resources"
    #vnet_name = "mtc-network"
    resource_group = terraform_variables['variable'][1]['resource_group_name']['default']
    vnet_name = terraform_variables['variable'][3]['vnet_name']['default']

    # Get the VNet details using the Network Management client
    vnet = network_client.virtual_networks.get(resource_group, vnet_name)

    assert vnet.provisioning_state == 'Succeeded', \
        f"Virtual Network {vnet_name} is not in the 'Succeeded' state, current state: {vnet.provisioning_state}"
    
    assert vnet.name == 'mtc-network', f"VNet name is not {vnet_name}, current name: {vnet.name}"
    
