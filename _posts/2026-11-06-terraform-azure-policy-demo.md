---
title: "Enforcing Azure Region Guardrails with HCP Terraform Policy"
date: 2026-11-06 14:06 +1300
categories: [Automation, Terraform]
tags: [terraform, hcp-terraform, terraform-policy, azure, governance, iac]
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://developer.hashicorp.com/terraform/language)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

## Policy checks in the Terraform workflow

Infrastructure as code makes cloud changes reviewable, but a plan still needs to be checked against organizational rules. HCP Terraform's native Terraform Policy framework adds that check to the Terraform workflow. Policies are written in HCL, evaluated against resources in a Terraform plan, and can prevent a run from proceeding to apply.

That is different from creating a policy in the cloud provider. For this example, the policy code lives in a VCS repository and is attached to an HCP Terraform policy set. HCP Terraform evaluates the AzureRM resources in a workspace plan; the demo does not create an Azure Policy definition or assignment.

The distinction is important: HCP Terraform Policy can stop a non-compliant HCP Terraform run before apply, but it does not evaluate Azure Portal, CLI, or other deployment requests outside workspaces that use the policy set.

## The rule: allow only approved Azure regions

For a concrete example, I wrote a policy that allows Azure resource groups and storage accounts to be planned only in approved regions. The allowed list is an input to the policy, with `australiaeast` as the demo default:

```hcl
input "allowed_locations" {
  type        = list(string)
  description = "Canonical Azure location names allowed by the policy."
  default     = ["australiaeast"]
  nullable    = false
}

resource_policy "azurerm_storage_account" "allowed_location" {
  enforcement_level = "mandatory"
  operations        = ["create", "update"]

  enforce {
    condition     = core::contains(input.allowed_locations, attrs.location)
    error_message = "Storage account location is not in the approved Azure locations list."
  }
}
```

The complete policy also checks `azurerm_resource_group`. Setting `operations` to `create` and `update` focuses enforcement on resources being added or changed, without failing plans just because an unchanged existing resource is outside the list.

Terraform Policy supports enforcement levels. A `mandatory` policy failure blocks the HCP Terraform run; `advisory` reports a violation but allows the operation to continue. I use mandatory enforcement for the test so an `eastus` location makes the plan fail before Azure receives a request.

## Testing policy code before connecting HCP Terraform

Terraform Policy includes a CLI, `tfpolicy`, for validating and testing policy files locally. The test file mocks AzureRM resources in both allowed and denied regions; it does not connect to Azure or provision anything.

```hcl
resource "azurerm_storage_account" "disallowed_location" {
  expect_failure = true

  attrs = {
    name                     = "stpolicyfail123"
    resource_group_name      = "rg-policy-fail"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}
```

After installing `tfpolicy`, validate and run the test suite from the demo directory:

```shell
tfpolicy validate --policies=policies/
tfpolicy test --policies=policies/ --tests=tests/
```

Local tests prove the policy behaves as intended for the test cases. The policy set is what connects that code to HCP Terraform workspace runs.

## Connecting the policy set to HCP Terraform

The [demo repository folder](https://github.com/diegosrp/diegosrp.github.io/tree/main/demos/terraform-azure-policy) contains the policy, tests, and a small Azure workload configuration:

- `policies/allowed-azure-locations.policy.hcl` defines the rule.
- `tests/allowed-azure-locations.policytest.hcl` checks passing and failing examples.
- `main.tf` defines a resource group and an optional storage account. It contains no Azure Policy resources.

To try it in HCP Terraform:

1. Connect the VCS repository to your HCP Terraform organization.
2. Create a policy set using **Terraform policy** as its framework and set the policy path to `demos/terraform-azure-policy/policies`.
3. Target a test workspace, with its working directory set to `demos/terraform-azure-policy`.
4. Configure the `allowed_locations` policy input and set mandatory enforcement.
5. Configure Azure provider authentication in the workspace and run a plan.

The workspace requires Terraform 1.17 or later for Terraform Policy. The plan is evaluated as part of the HCP Terraform run.

## Seeing a denied plan

The workload configuration defaults to `australiaeast`, so its plan should pass. To test a disallowed region, set these Terraform variables in the HCP workspace:

```text
deploy_test_storage      = true
storage_account_location = "eastus"
```

Start a run. HCP Terraform evaluates the proposed storage account against the policy, marks the policy as failed, and stops before apply because enforcement is mandatory. The blocked run should not create the storage account.

Change the location to `australiaeast` and run a new plan to see it pass. Applying that passing plan creates a billable storage account, so review the plan first and destroy demo resources when finished.

## HCP Terraform Policy or Azure Policy?

For this region rule, both can reject a deployment to `eastus`, but they evaluate it at different points:

| | HCP Terraform Policy | Azure Policy |
|---|---|---|
| **Evaluates** | Resources in an HCP Terraform plan | Azure resource requests and, depending on the policy, existing resources |
| **Can block** | The HCP Terraform run before apply | A non-compliant Azure create or update request |
| **Scope** | Policy set targets in HCP Terraform: organization, project, Stack, or selected workspace | Azure management group, subscription, resource group, or resource, depending on assignment |
| **Covers other deployment tools?** | No; only HCP Terraform runs targeted by the policy set | Yes; requests from other tools are evaluated within the Azure assignment scope |

With HCP Terraform Policy, a team gets feedback while reviewing its Terraform run, before the deployment reaches Azure. Azure Policy is enforced on the Azure side and can cover requests from the portal, CLI, and other tools too. The HCP policy is not a cloud-wide guardrail, and Azure Policy is not required for this HCP Terraform Policy demo.

For organizations that need both developer feedback and consistent protection across deployment paths, the controls can complement one another. For this demo, however, the region rule is intentionally implemented only in HCP Terraform Policy.

## References

- [Terraform Policy in HCP Terraform](https://developer.hashicorp.com/terraform/cloud-docs/policy-enforcement/define-policies/terraform-policy)
- [Terraform Policy language and resource policies](https://developer.hashicorp.com/terraform/policy/reference/policy/resource-policy)
- [Policy test configuration](https://developer.hashicorp.com/terraform/policy/reference/test)
- [Install the `tfpolicy` CLI](https://developer.hashicorp.com/terraform/policy/install)
- [VCS setup for Terraform Policy](https://developer.hashicorp.com/terraform/cloud-docs/policy-enforcement/manage-policy-sets/vcs/terraform-policy-vcs)
