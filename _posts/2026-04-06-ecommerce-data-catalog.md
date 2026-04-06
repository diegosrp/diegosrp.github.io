---
title: "Challenge - DIO Cloud Native E-commerce Data Catalog"
date: 2026-04-06 00:00 +1300
categories: [PlaySpace, Demos]
tags: [azure, cloud, ecommerce, iac, terraform, streamlit, security, private-endpoints, managed-identity] 
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
[![Python](https://img.shields.io/badge/language-Python-yellow)](https://www.python.org/)

---

<br>

This project was built for [DIO](https://www.dio.me/)'s Microsoft Azure Cloud Native challenge: **"Storing E-commerce Data in the Cloud"**. The idea was to create a Streamlit application that stores product metadata in Azure SQL and images in Blob Storage.

It was initially created via ClickOps, then I migrated everything to Terraform, adding proper networking, identity, and security practices along the way.

---

## Architecture

![](/assets/img/posts/dio_architecture_visualizer.png)

<br>

The user accesses the app through a public URL, registers products with name, description, price, and image. Metadata goes to Azure SQL, images go to Blob Storage. Both services are private, only accessible through the VNet.

![](/assets/img/posts/dio_add_product.png)

![](/assets/img/posts/dio_product_catalog.png)

In short: public user experience, private backend communication.

---

## What was done

### Infrastructure as Code

Everything is managed with Terraform. A single `terraform apply` creates the full environment: resource group, VNet, subnets, storage, SQL, App Service, private endpoints, DNS zones, managed identity, and RBAC.

---

### Private Endpoints

Both the SQL Server and the Storage Account have `public_network_access_enabled = false`. All traffic between the app and data services flows through Private Endpoints inside the VNet.

Even if someone gets the connection string, they cannot connect from outside the virtual network.

![](/assets/img/posts/dio_private_endpoint_sql1.png)
![](/assets/img/posts/dio_private_endpoint_sql2.png)
![](/assets/img/posts/dio_private_endpoint_st1.png)
![](/assets/img/posts/dio_private_endpoint_st2.png)

---

### Managed Identity

No credentials stored anywhere. The app uses a **User-Assigned Managed Identity** to authenticate with Azure services. This approach is superior to System-Assigned because it decouples the identity lifecycle from the compute resource—perfect for scenarios where the same identity might be reused across multiple apps or services in the future.


---

### SQL Serverless

The database uses `GP_S_Gen5_1` (General Purpose Serverless), which auto-pauses after 60 minutes of inactivity and scales from 0.5 to 2 vCores on demand. In a lab environment like this, auto-pause alone can reduce idle costs by ~80% compared to always-on provisioned databases.

![](/assets/img/posts/dio_sql_serverless1.png)
![](/assets/img/posts/dio_sql_serverless2.png)

---

### VNet Integration

The Web App uses VNet Integration with `vnet_route_all_enabled = true`, so all outbound traffic goes through the VNet. This is what makes the Private Endpoints and DNS resolution work end to end.

![](/assets/img/posts/dio_vnet_integration.png)

---

### Application Security

The Python code also follows good practices:

- **Parameterized queries** to prevent SQL injection
- **Image validation** (format, size, dimensions, decompression bomb protection)
- **Filename sanitization** for blob names
- **HTML escaping** in the catalog rendering
- **Blob rollback** if the database insert fails

---

## What can still be improved

- Split Terraform into modules (network, data, app, security)
- Add CI/CD pipeline with lint, tests, and security scanning
- Break `main.py` into smaller modules
- Integrate Application Insights
- Add health checks and retry policies

<br>

## Conclusion

The delivered solution fully meets the challenge goal: a Streamlit catalog app exposed publicly, with Azure SQL and Blob Storage protected behind private endpoints and VNet routing.

The environment is fully reproducible with Terraform and includes identity, networking, and access controls by design. More importantly, the foundation is solid enough to evolve modularizing Terraform, adding CI/CD pipelines, integrating Application Insights, and improving code structure are all natural next steps that the architecture already supports. This is a working solution that's ready to grow.

---

References: 
[Repository](https://github.com/diegosrp/dio-cloud-native-ecommerce-data-catalog), 
[Azure Private Endpoints](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview?wt.mc_id=MVP_473705), 
[Managed Identities](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview?wt.mc_id=MVP_473705), 
[SQL Serverless](https://learn.microsoft.com/en-us/azure/azure-sql/database/serverless-tier-overview?view=azuresql&wt.mc_id=MVP_473705&tabs=general-purpose) 