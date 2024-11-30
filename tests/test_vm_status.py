# Test to check if the Azure Virtual Machine is in the "Running" state
def test_virtual_machine_status(compute_client, terraform_variables):
    # Use the variables parsed from variables.tf
    resource_group = terraform_variables['variable'][1]['resource_group_name']['default']
    #print(resource_group)
    vm_name = terraform_variables['variable'][2]['vm_name']['default']
    #print(vm_name)

    # Get the VM's details
    vm = compute_client.virtual_machines.get(resource_group, vm_name, expand='instanceView')

    # Assert that the VM's power state is in a "Running" state
    assert vm.instance_view.statuses[1].code == 'PowerState/running', \
        f"Virtual Machine {vm_name} is not in the 'Running' state, current state: {vm.instance_view.statuses[1].code}"
        
    assert vm.hardware_profile.vm_size == "Standard_B1s", \
        f"VM {vm_name} is not provisioned with the correct size, expected 'Standard_B1s'"

