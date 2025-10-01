---
title: avm-alz VS caf-enterprise 
date: 2025-08-05 22:00 +1300
categories: [Azure - Landing zone, avm-alz]
tags: [hashicorp, terraform, iac, automation, infrastructure, governance]
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

This will be a short and straightforward post highlighting the key differences I’ve found between the new landing zone module AVM-ALZ and the legacy CAF Enterprise module.

Just for context, the CAF Enterprise module has been deprecated and will no longer receive new features, although it is still supported as of today. However, the new AVM-ALZ module is now the recommended approach for new deployments.

---

### CAF Enterprise

- It is a single module that includes submodules for **core**, **identity**, **management**, and **connectivity**.
<br>

- Being monolithic, it tends to be complex and creates dependencies between submodules. (For example, if you want to separate environments or identities to avoid a blast radius, you would need to duplicate the module code and set some parameters to `false`. This approach makes the code harder to maintain and understand).
<br>

- The main provider is **AzureRM**, which limits available features since not all Azure resources are supported. (It is also often difficult to customize, reducing flexibility in many use cases).

![](/assets/img/posts/caf_caf_features.png){: .left }

<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

---

### AVM-ALZ

- Built as separate modules, providing a more modular and flexible structure.
- Highly customizable to fit different scenarios and organizational needs.
- Uses both **AzAPI** and **AzureRM** providers, enabling faster support for new Azure resources, improved customization, and better performance.

![](/assets/img/posts/caf_alz_features.png){: .left }

<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>


# Conclusion

While the previous CAF had its complexities and challenges, I believe it served its purpose well. However, as the environment evolved and new features were introduced, I believe its maintainers felt this update was the best approach.


I recommend accessing the official project documentation to perform the deployment. You can also see that there are other modules available that can be used to complement your landing zone. 
 
 References: [Documentation](https://azure.github.io/Azure-Landing-Zones/terraform/#why-have-we-made-this-change), [Terraform Pattern Modules](https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-pattern-modules/)