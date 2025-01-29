---
title: Azure Workbooks
date: 2025-01-30 00:15 +1300
categories: [Cloud, Azure]
tags: [cloud, microsoft, azure, infrastructure, security, governance, management, workbook, dashboard]
image:
  path: https://stpersonalblog24.blob.core.windows.net/titles/azure_workbooks.png
---

[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

## What are <a href="https://learn.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview" target="_blank">Azure Workbooks?</a>

Azure Workbooks are interactive and modular dashboards used to create reports and visualizations in Azure Monitor. They enable you to design customized views that can include metrics, logs, and data from other Azure sources, providing a consolidated and interactive overview of your cloud environment.

## Key Benefits of Azure Workbooks

- **Interactive Visualizations:** Create interactive charts, tables, and reports tailored to meet specific business and operational needs.  
- **Integration with Azure Data:** Combine data from various Azure sources, including activity logs, performance metrics, and billing information.  
- **Sharing and Collaboration:** Workbooks can be shared across teams, fostering collaboration between finance, operations, and IT.  
- **Automation and Continuous Updates:** Set up automatic updates to ensure the displayed data is always current.  
<br>

---

## I will share some workbooks that might be useful or provide insights into what is possible to achieve

### **1 - Governance Workbook**
The governance workbook is an Azure Monitor workbook that provides a comprehensive overview of the governance posture of your Azure environment. It includes the standard metrics aligned with the Cloud Adoption Framework for all disciplines and has the capability to identify and apply recommendations to address non-compliant resources.

 <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fmicrosoft.github.io%2Ffinops-toolkit%2Fdeploy%2Fgovernance-workbook-latest.json/createUIDefinitionUri/https%3A%2F%2Fmicrosoft.github.io%2Ffinops-toolkit%2Fdeploy%2Fgovernance-workbook-latest.ui.json" ><img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure button"></a>
![](https://stpersonalblog24.blob.core.windows.net/posts/azure_workbooks_governance.png)
Reference: <a href="https://microsoft.github.io/finops-toolkit/workbooks/governance" target="_blank">FinOps toolkit</a>

### **2 - Cost optimization Workbook**
The cost optimization workbook is an Azure Monitor workbook that provides a single pane of glass for cost optimization, modeled after the Well-Architected Framework guidance.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fmicrosoft.github.io%2Ffinops-toolkit%2Fdeploy%2Foptimization-workbook-latest.json/createUIDefinitionUri/https%3A%2F%2Fmicrosoft.github.io%2Ffinops-toolkit%2Fdeploy%2Foptimization-workbook-latest.ui.json" ><img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure button"></a>
![](https://stpersonalblog24.blob.core.windows.net/posts/azure_workbooks_optimization.png)
Reference: <a href="https://microsoft.github.io/finops-toolkit/workbooks/optimization" target="_blank">FinOps toolkit</a>

### **3 - Orphan Resources Workbook**
The Orphan Resources Workbook is an Azure Monitor workbook designed to identify and manage orphaned resources in Azure environments. It helps reduce costs, prevent misconfigurations, and simplify operations by providing a centralized view of unused or unnecessary resources.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdolevshor%2Fazure-orphan-resources%2Fmain%2FWorkbook%2FAzure%2520Orphaned%2520Resources%2520v3.0.json" ><img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure button"></a>
![](https://stpersonalblog24.blob.core.windows.net/posts/azure_workbooks_orphan.png)
Reference: <a href="https://techcommunity.microsoft.com/blog/fasttrackforazureblog/azure-orphan-resources/3492198" target="_blank">Techcommunity Blog</a>

### **4 - Azure Inventory Workbook**
The Azure Inventory is a monitoring and management workbook that provides a comprehensive view of resources deployed in the Azure environment. It gathers information about resources such as names, types, regions, resource groups, subscriptions, tags, costs, and more, enabling organizations to maintain control and visibility of their environment efficiently.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FSumit1551%2FAzure-Workbooks-Inventory%2Frefs%2Fheads%2Fmain%2FARM%2520template.json" ><img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure button"></a>
![](https://stpersonalblog24.blob.core.windows.net/posts/azure_workbooks_inventory.png)
Reference: <a href="https://github.com/Sumit1551/Azure-Workbooks-Inventory/tree/main" target="_blank">Sumit1551's GitHub</a>

### **5 - Azure Firewall Workbook**
The Azure Firewall Security Workbook is an Azure Monitor workbook designed to visualize security-related Azure Firewall events across multiple filterable panels for a Multi-Tenant/Workspace view. It supports all Azure Firewall data types, including Application Rule Logs, Network Rule Logs, DNS Proxy logs, and ThreatIntel logs. You can import it via ARM Template or Gallery Template.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2FAzure-Network-Security%2Fmaster%2FAzure%2520Firewall%2FWorkbook%2520-%2520Azure%2520Firewall%2520Monitor%2520Workbook%2FAzure%2520Firewall_ARM.json" ><img src="https://aka.ms/deploytoazurebutton" alt="Deploy to Azure button"></a>
![](https://github.com/Azure/Azure-Network-Security/blob/master/Cross%20Product/MediaFiles/Azure-Firewall/AzFwWorkbook.png?raw=true)
Reference: <a href="https://learn.microsoft.com/en-us/azure/firewall/firewall-workbook" target="_blank">Microsoft Learn</a>

<br>

## Conclusion
Azure Workbooks is a powerful tool that provides enhanced visibility and control over your cloud resources and environments. By integrating data from various sources and creating interactive, customized visualizations, organizations can identify optimization opportunities, make informed decisions, and continuously improve operational efficiency.