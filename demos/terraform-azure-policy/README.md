# HCP Terraform Policy: Azure allowed locations

This demo uses HashiCorp's native Terraform Policy framework in HCP Terraform to evaluate Azure infrastructure plans. It does **not** create or assign an Azure Policy. The `tfpolicy` source code checks AzureRM resource locations in the Terraform plan and can stop an HCP Terraform run before Terraform applies it.

The policy checks `azurerm_resource_group` and `azurerm_storage_account` resources for the canonical Azure location names in `allowed_locations`. The default is `australiaeast`. Change the input in the policy set or its default to match your organization's approved regions.

## Files

- `policies/allowed-azure-locations.policy.hcl`: HCP Terraform Policy rules, targeting AzureRM resource types.
- `tests/allowed-azure-locations.policytest.hcl`: local pass/fail tests using mocked plan resources.
- `main.tf`: small Azure workload configuration for an HCP Terraform workspace. It contains no Azure Policy resources.

The workload configuration creates a resource group and can optionally create a storage account. The storage account is disabled by default; enabling it creates a billable Azure resource.

## Requirements

- HCP Terraform organization with access to create policy sets and attach them to a workspace
- Terraform 1.17 or later for HCP Terraform runs using Terraform Policy
- `tfpolicy` CLI to validate and test policies locally
- An Azure provider authentication method configured for the HCP Terraform workspace

The Terraform Policy framework evaluates plans only in HCP Terraform runs where the policy set is attached. It does not guard a local `terraform apply` or runs in a workspace that is not targeted by the policy set.

## Validate and test locally

Install `tfpolicy` from the [official HashiCorp releases](https://releases.hashicorp.com/tfpolicy/), then run:

```shell
tfpolicy validate --policies=policies/
tfpolicy test --policies=policies/ --tests=tests/
```

The tests cover both allowed and disallowed regions for resource groups and storage accounts. They use mocked resources and do not connect to Azure or create resources.

## Connect the policy to HCP Terraform

1. Push this repository to a VCS repository connected to your HCP Terraform organization.
2. In HCP Terraform, open **Settings > Policy Sets** and create a policy set using **VCS** as its source and **Terraform policy** as its framework.
3. Select this repository and set **Policies Path** to `demos/terraform-azure-policy/policies`.
4. For this demonstration, scope the policy set to the workspace that runs the workload in `demos/terraform-azure-policy`. Set that workspace's working directory to the same folder.
5. Set the policy input `allowed_locations` to `["australiaeast"]` (or use the default) and choose a **mandatory** enforcement level.
6. Configure Azure authentication in the workspace, then run a plan. The policy set evaluates the plan as part of the HCP Terraform run.

## Demonstrate the rule

The default resource group location is `australiaeast`, so its plan should pass. To test a denied plan, set these workspace Terraform variables:

```text
deploy_test_storage    = true
storage_account_location = "eastus"
```

Start a new HCP Terraform run. The location policy should fail during policy evaluation, and a mandatory failure stops the run before Terraform applies the plan. No storage account should be created by that blocked run.

Change `storage_account_location` to `australiaeast` and run the plan again to demonstrate a passing location. Applying the passing plan creates a billable storage account. Review the plan before applying and destroy the demo resources when finished.

## What this does not do

This Terraform Policy rule validates only the resource types named in its `resource_policy` blocks and only for HCP Terraform runs targeted by the policy set. It does not evaluate Azure requests made through the portal, Azure CLI, another Terraform workspace, or a different deployment tool. If the region restriction must be enforced across all Azure deployment paths, Azure Policy is a separate cloud-side control and may complement this HCP Terraform policy.

## References

- [Terraform Policy in HCP Terraform](https://developer.hashicorp.com/terraform/cloud-docs/policy-enforcement/define-policies/terraform-policy)
- [Write Terraform policies](https://developer.hashicorp.com/terraform/policy/write)
- [Terraform Policy resource policy reference](https://developer.hashicorp.com/terraform/policy/reference/policy/resource-policy)
- [Write and run policy tests](https://developer.hashicorp.com/terraform/policy/write/tests)
- [VCS setup for Terraform Policy](https://developer.hashicorp.com/terraform/cloud-docs/policy-enforcement/manage-policy-sets/vcs/terraform-policy-vcs)
