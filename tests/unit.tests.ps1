Describe 'Terraform Pester Demo Tests' {
    BeforeAll -ErrorAction Stop {
        Write-Host "Test Case: Pester Demo" -ForegroundColor Magenta
        Write-Host 'Validating...'

        # Parse the Terraform plan file
        $Plan = terraform show -json tf_plan/terraform.plan | ConvertFrom-Json

        # Debug output to check the full plan content
        #Write-Host "Full Plan Content: $($Plan | ConvertTo-Json -Depth 1)"

        # Ensure that resource_changes contains the expected resource (azurerm_resource_group.mtc-rg)
        $ResourceGroupAddress  = 'azurerm_resource_group.mtc-rg'
        $ResourceGroupPlan = $Plan.resource_changes | Where-Object { $_.address -eq $ResourceGroupAddress }

        # Virtual Network Plan
        $VirtualNetworkAddress = 'azurerm_virtual_network.mtc-vn'
        $VirtualNetworkPlan = $Plan.resource_changes | Where-Object { $_.address -eq $VirtualNetworkAddress }
        
        # Debugging output
        Write-Host "Resource Group Plan Found: $($ResourceGroupPlan.address)"
        Write-Host "Virtual Network Plan Found: $($VirtualNetworkPlan.address)"

        # Debug output to verify the resource group plan found
        #Write-Host "Resource Group Plan: $($ResourceGroupPlan | ConvertTo-Json -Depth 1)"

        # Store the Variables
        $Variables = $Plan.Variables
    }

    Context 'Unit' -Tag Unit {
        BeforeAll {
            # Check that the resource plan is valid and contains the necessary fields
            if ($ResourceGroupPlan) {
                Write-Host "Resource Group Plan Found: $($ResourceGroupPlan.address)"
            } else {
                Write-Host "Resource Group Plan NOT found!"
            }
            if ($VirtualNetworkPlan) {
                Write-Host "Virtual Network Plan Details: $($VirtualNetworkPlan | ConvertTo-Json -Depth 2)"
            } else {
                Write-Host "Virtual Network Plan NOT found!"
            }
        }
    }

    # Region Resource Group Tests
    It 'Will create resource_group' {
        # Check if the 'change' field exists and contains 'actions'
        if ($ResourceGroupPlan.change -and $ResourceGroupPlan.change.actions) {
            Write-Host "RG Actions found: $($ResourceGroupPlan.change.actions)"
            $ResourceGroupPlan.change.actions | Should -Contain 'create'
        } else {
            Write-Host "Error: No actions found in $($ResourceGroupPlan | ConvertTo-Json -Depth 1)"
        }
    }

    It 'Will create resource_group in correct region' {
        # Normalize region names (strip spaces from both expected and actual values)
        $ExpectedRegion = $Variables.azure_region.value.Replace(" ", "").ToLower()
        $ActualRegion = $ResourceGroupPlan.change.after.location.ToLower()

        Write-Host "Expected Region: $ExpectedRegion"
        Write-Host "Actual Region: $ActualRegion"

        # Compare the actual and expected region values
        $ActualRegion | Should -Be $ExpectedRegion
    }

    It 'Will create resource_group with correct name' {
        $ExpectedName = $Variables.resource_group_name.value
        $ActualName = $ResourceGroupPlan.change.after.name

        Write-Host "Expected RG Name: $ExpectedName"
        Write-Host "Actual RG Name: $ActualName"

        # Compare the actual and expected names
        $ActualName | Should -Be $ExpectedName
    }


    #Region Virtual Network Tests
    It 'Will create virtual_network' {
        # Check if the 'change' field exists and contains 'actions'
        if ($VirtualNetworkPlan -and $VirtualNetworkPlan.change -and $VirtualNetworkPlan.change.actions) {
            Write-Host "VNet Actions found: $($VirtualNetworkPlan.change.actions)"
            $VirtualNetworkPlan.change.actions | Should -Contain 'create'
        } else {
            Write-Host "Error: No actions found in $($VirtualNetworkPlan | ConvertTo-Json -Depth 1)"
        }
    }

    It 'Will create virtual_network in correct region' {
        # Normalize region names (strip spaces from both expected and actual values)
        $ExpectedRegion = $Variables.azure_region.value.Replace(" ", "").ToLower()
        $ActualRegion = $VirtualNetworkPlan.change.after.location.ToLower()
    
        Write-Host "Expected Region: $ExpectedRegion"
        Write-Host "Actual Region: $ActualRegion"
    
        # Compare the actual and expected region values
        $ActualRegion | Should -Be $ExpectedRegion
    }

    It 'Will create virtual_network with correct name' {
        $ExpectedName = $Variables.vnet_name.value
        $ActualName = $VirtualNetworkPlan.change.after.name

        Write-Host "Expected VNet Name: $ExpectedName"
        Write-Host "Actual VNet Name: $ActualName"

        # Compare the actual and expected names
        $ActualName | Should -Be $ExpectedName
    }
}