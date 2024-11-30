#import pytest

#@pytest.mark.parametrize("resource_group_name, nsg_name", [
#    ("mtc-resources", "mtc-sg")
#])

def test_nsg_allow_ssh(network_client, terraform_variables):
    """Test if NSG allows inbound SSH traffic on port 22."""
    nsg_name = terraform_variables['variable'][4]['nsg_name']['default']
    resource_group = terraform_variables['variable'][1]['resource_group_name']['default']
    nsg = network_client.network_security_groups.get(resource_group, nsg_name)
    
    # Find the security rule for SSH (port 22)
    ssh_rule = next((rule for rule in nsg.security_rules if rule.name == "allow-ssh"), None)
    
    # Check if the SSH rule exists and is allowing inbound traffic
    assert ssh_rule is not None, "Allow-SSH rule not found in NSG."
    assert ssh_rule.direction == "Inbound", "SSH rule direction is not 'Inbound'."
    assert ssh_rule.access == "Allow", "SSH rule does not allow access."
    assert ssh_rule.destination_port_range == "22", "SSH rule does not allow port 22."