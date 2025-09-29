---
title: Azure Subnet Peering
date: 2025-08-25 22:00 +1300
categories: [PlaySpace, Demo]
tags: [cloud, microsoft, azure, infrastructure, subnet, peering, vnet]
image:
  path: /assets/img/titles/snet_peering.png
---

[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

---

Currently, the subnet peering feature is available in all Azure regions, but it can only be configured using Terraform, PowerShell, API, Azure CLI, and ARM templates.

To use this feature, you must register the **AllowMultiplePeeringLinksBetweenVnets** feature in the **Microsoft.Network** namespace.

If you haven't done this yet, you can use the following CLI command to register the feature and update the provider:
```
az feature register --namespace Microsoft.Network --name AllowMultiplePeeringLinksBetweenVnets && \
az provider register -n Microsoft.Network
```
![](/assets/img/posts/snet_peering_register.png){: .left }

<br><br><br><br><br><br>


Then confirm that the feature was successfully registered using the following command:
```
az feature show --name AllowMultiplePeeringLinksBetweenVnets --namespace Microsoft.Network --query 'properties.state' -o tsv
```
![](/assets/img/posts/snet_peering_validate.png){: .left }

<br><br>

After that, you can start testing the subnet peering feature between VNets.

---
<br>
To test and explore this functionality, I created a sample lab architecture using Terraform, available on [GitHub](https://github.com/diegosrp/azure-subnet-peering)

1. **null_resource:** executes a local-exec provisioner to register the feature `AllowMultiplePeeringLinksBetweenVnets` and update the provider.
2. **Resource Group:** `rg-snet-peering` — contains all lab resources.
3. **Network Security Groups (NSG):** `nsg-left`, `nsg-right` — control traffic for the subnets.
4. **Virtual Networks (VNets) and Subnets:**
   - `vnet-left` (`10.0.0.0/16`)
     - `snet1-left` (`10.0.1.0/24`)
     - `snet2-left` (`10.0.3.0/24`)
     - `snet3-left` (`10.0.5.0/24`) <br><br>

   - `vnet-right` (`10.1.0.0/16`)
     - `snet1-right` (`10.1.1.0/24`)
     - `snet2-right` (`10.1.3.0/24`)
     - `snet3-right` (`10.1.5.0/24`) <br>
     **NOTE:** Peering is configured only between `snet1-left` to `snet1-right`, `snet2-right` and vice-versa.
5. **Bastion Hosts:** `bas-vnet-left`, `bas-vnet-right` — secure access to VMs.
6. **null_resource:** executes a local-exec provisioner to register the feature `EncryptionAtHost`.
7. **Key Vault:** stores the SSH private key for VM access.
8. **Virtual Machines (VMs):** one VM per subnet for testing. <br><br>

After deploying the resources, navigate to `vnet-left` under Settings > Address space. Here, you'll notice that the address spaces for the remote subnets **snet1-right** and **snet2-right** are visible. You can also verify connectivity by checking the effective routes on each **NIC**.
![](/assets/img/posts/snet_peering_vnet_left_addressspace.png){: .left }

![](/assets/img/posts/snet_peering_vm_snet1_left_nic.png){: .left } 


<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

In vnet-right under Settings > Address space you will see the address space for the remote subnet **snet1-left**.
![](/assets/img/posts/snet_peering_vnet_right_addressspace.png){: .left }

<br><br><br><br><br><br><br><br>

When you access `vm-snet1-left` via Bastion and try to ping `vm-snet1-right` and `vm-snet2-right`, the ping works as expected. However, if you try to ping `vm-snet3-right`, the ping fails because there is no peering configured between these subnets.
![](/assets/img/posts/snet_peering_vm_snet1_left_ping.png){: .left }

<br><br><br><br><br><br><br><br><br><br><br><br><br><br>

However, if you access `vm-snet3-right` and try to ping any subnet in `vnet-left`, it will not work because there is no peering configured between these subnets.
![](/assets/img/posts/snet_peering_vm_snet3_right_ping.png){: .left }


<br><br><br><br><br><br><br><br><br><br><br>

If you want to experiment with the lab by disabling peering between the subnets, simply set the `enable_peering` variable to `false`.


---

I'm also adding some reference links on the topic published by Microsoft <br>
[Subnet Peering](https://techcommunity.microsoft.com/blog/azurenetworkingblog/subnet-peering/4397640) <br>
[Introducing Subnet Peering in Azure](https://techcommunity.microsoft.com/blog/azurenetworkingblog/introducing-subnet-peering-in-azure/4383841) <br>
[How to configure subnet peering](https://learn.microsoft.com/en-us/azure/virtual-network/how-to-configure-subnet-peering#subnet-peering-checks-and-limitations) <br>

More details about [Bastion Developer](https://learn.microsoft.com/en-us/azure/bastion/quickstart-developer)







