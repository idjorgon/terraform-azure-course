variables {
    location = "East Us"
    resource_group_name = "mtc-rg"
    virtual_network_name = "mtc-network"
    env = "dev"
}

provider "azurerm" {
    features {}
}

run "unit_tests" {
    command = plan

    variables {
        resource_group_name = var.resource_group_name
    }

    assert {
        condition = azurerm_resource_group.mtc-rg.name == var.resource_group_name
        error_message = "Resource Group name is not expected"
    }

    assert {
        condition = azurerm_virtual_network.mtc-vn.name == var.virtual_network_name
        error_message = "Virtual Network name is not expected"
    }

    assert {
        condition = azurerm_network_security_rule.mtc-dev-rule.access == "Allow"
        error_message = "Security Rule Access is not expected"
    }
}