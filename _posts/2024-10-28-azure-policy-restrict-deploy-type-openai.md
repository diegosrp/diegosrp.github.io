---
title: Azure Policy - Restrict deployment types for Azure OpenAI
date: 2024-10-28 22:00 +1300
categories: [Cloud, Azure]
tags: [cloud, microsoft, azure, policy, governance, infrastructure, security, finops, openai, ai, json]
---

[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

## Deployment type overview

Azure OpenAI offers in this moment, three main deployment types, each optimized for different latency, throughput, and cost requirements:

- **Global Standard**: Configured for global routing, enabling real-time calls and high quotas, ideal for medium to high-volume use cases.
- **Standard**: Geared toward low to medium-volume workloads, with a pay-per-call model and flexibility for variable loads.
- **Provisioned Managed**: Allows specifying the required throughput for consistent, predictable workloads, with hourly billing and an option for monthly or yearly reservations.

## Purpose

With the growing adoption of AI, new deployment options emerge, not all of which are widely understood. This policy enhances governance by limiting deployment choices, helping to prevent unsuitable selections that may lead to unexpected costs or performance issues.

## How to Use

This policy is designed for easy integration and customization, allowing adjustments to permitted deployment types. The default configuration includes a list of allowed deployment types that can be edited to align with your organization’s guidelines.

```json
{
  "mode": "All",
  "policyRule": {
    "if": {
      "allOf": [
        {
          "equals": "Microsoft.CognitiveServices/accounts/deployments",
          "field": "type"
        },
        {
          "field": "Microsoft.CognitiveServices/accounts/deployments/sku.name",
          "notIn": "[parameters('allowedSkus')]"
        }
      ]
    },
    "then": {
      "effect": "[parameters('effect')]"
    }
  },
  "parameters": {
    "allowedSkus": {
      "type": "Array",
      "metadata": {
        "displayName": "Allowed Deployment Types",
        "description": "Select the allowed Deployment Types for deployment"
      },
      "allowedValues": [
        "Standard",
        "Provisioned-Managed",
        "GlobalStandard"
      ],
      "defaultValue": [
        "Standard",
        "GlobalStandard"
      ]
    },	
    "effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect for the others",
        "description": "Enable or disable the enforcement of the policy"
      },
      "allowedValues": [
        "AuditIfNotExists",
        "Deny",
        "Disabled"
      ],
      "defaultValue": "Deny"
    }
  }
}
```

## Policy Parameters

- **allowedSkus**: Defines the permitted deployment types (e.g., "Standard," "GlobalStandard").
- **effect**: Specifies the policy’s effect for unpermitted deployments (e.g., "AuditIfNotExists," "Deny").

---

The repository contains an Azure policy designed to restrict available deployment types for Azure OpenAI, initially configured to limit the **Provisioned-Managed** type. The policy allows you to select and customize permitted deployment types based on your organization’s needs.

<br>
Repository: <a href="https://github.com/diegosrp/policy-restrict-azure-openai-deployment-types/blob/main/policy_definition_restrict_deployment_types_azure_openai.json" target="_blank">https://github.com/diegosrp/policy-restrict-azure-openai-deployment-types</a>