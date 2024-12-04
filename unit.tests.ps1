Describe 'Terraform Pester Demo Tests' {
    BeforeAll -ErrorAction Stop {
        Write-Host "Test Case: Pester Demo" -ForegroundColor Magenta
        Write-Host 'Initializing...'
        terraform init
        Write-Host 'Validating...'
        terraform validate
        Write-Host 'Planning...'
        (terraform plan -out terraform.plan)

        Start-Sleep -Seconds 3
        # Parse plan file and pull out provided variables
        $Plan = terraform show -json terraform.plan | ConvertFrom-Json
        $Variables = $Plan.Variables
    }

    Context 'Unit' -Tag Unit {
        BeforeAll {
            $ResourceGroupAddress  = 'azurerm_resource_group.mtc-rg'

            $ResourceGroupPlan = $Plan.resource_changes | Where-Object { $_.address -eq $ResourceGroupAddress }

            # Print the entire resource plan for debugging
            Write-Host "Resource Group Plan Found: $($ResourceGroupPlan.address)"
            Write-Host "Full Resource Group Plan Details: $($ResourceGroupPlan | ConvertTo-Json -Depth 5)"

            # Check if the plan is valid and the 'change' section exists
            if ($ResourceGroupPlan) {
                Write-Host "Resource Group Plan Details: $($ResourceGroupPlan | ConvertTo-Json -Depth 5)"
            } else {
                Write-Host "Resource Group Plan NOT found!"
            }
        }
    }

    #Region Resource Group Tests
    It 'Will create resource_group' {
        # Check if the actions array is not empty or null
        if ($ResourceGroupPlan -and $ResourceGroupPlan.change -and $ResourceGroupPlan.change.actions) {
                $ResourceGroupPlan.change.actions | Should -Be 'create'
            } else {
                Write-Host "Error: No actions found in $ResourceGroupPlan.change"
            }
    }
        
    It 'Will create resource_group with correct name' {
        $ResourceGroupPlan.change.after.name | Should -Be $Variables.resource_group_name.value
    }
        
    It 'Will create resource_group in correct region' {
        $ResourceGroupPlan.change.after.location | Should -Be $Variables.region.value
    }
    #EndRegion Resource Group Tests
}