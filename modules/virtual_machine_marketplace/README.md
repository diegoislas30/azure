# virtual_machine_marketplace

Módulo de Terraform para crear **máquinas virtuales de Azure** usando **imágenes de Azure Marketplace** (`publisher/offer/sku/version`), **sin IP pública** y **sin NSG** en NIC/VM (se asume NSG a nivel **subnet**).  
Incluye **Trusted Launch** opcional, **OS disk** parametrizable, **data disks** gestionados con attachments y **IP privada dinámica o estática**.

---

## Características

- VM **Linux** o **Windows** (`os_type`).
- Imagen desde **Marketplace** (`marketplace_image`).
- **Trusted Launch** (si la imagen es Gen2 y el tamaño lo soporta).
- NIC sin IP pública; **NSG** se espera **en la subnet**.
- **IP privada dinámica o estática**.
- **OS Disk** y **Data Disks** con SKUs y caching configurables.
- **Availability Zone** opcional (`zone`).
- **Accelerated Networking** opcional (si el tamaño/región lo soporta).
- **Tags** obligatorios (objeto con 5 claves).

---

## Requisitos

- Provider `azurerm` ≥ **3.116** (probado con 3.117.x).
- Permisos para crear VMs/NICs/Discos.
- Si la imagen de Marketplace requiere **términos** (licencia), acéptalos previamente.

---

## Entradas

| Variable | Tipo | Default | Descripción |
|---|---|---:|---|
| `vm_name` | string | – | Nombre de la VM. |
| `resource_group_name` | string | – | RG destino. |
| `location` | string | – | Región (ej. `southcentralus`). |
| `subnet_id` | string | – | ID de la subnet (NIC sin IP pública). |
| `os_type` | string | – | `"linux"` o `"windows"`. |
| `vm_size` | string | `"Standard_B1s"` | Tamaño de VM. |
| `zone` | string\|null | `null` | AZ `"1"`, `"2"`, `"3"`. |
| `security_type` | string | `"TrustedLaunch"` | `"TrustedLaunch"` o `"Standard"`. |
| `marketplace_image` | object | – | `{ publisher, offer, sku, version }` (permite `"latest"`). |
| `admin_username` | string | `"spyderadmin"` | Usuario admin. |
| `admin_password` | string (sens.) | – | Contraseña admin. |
| `os_disk_size_gb` | number | `128` | Tamaño OS disk. |
| `os_disk_storage_account_type` | string | `"StandardSSD_LRS"` | SKU OS disk. |
| `os_disk_caching` | string\|null | `null` → RW | `None` / `ReadOnly` / `ReadWrite`. |
| `data_disks` | list(object) | `[]` | `[{ lun, size_gb, caching?, storage_account_type? }]`. |
| `enable_accelerated_networking` | bool | `false` | Habilita AN en NIC. |
| `boot_diagnostics_storage_uri` | string\|null | `null` | URI Storage para boot diagnostics. |
| `tags` | object | – | `{ UDN, OWNER, xpeowner, proyecto, ambiente }`. |
| `private_ip_version` | string | `"IPv4"` | `"IPv4"` o `"IPv6"`. |
| `private_ip_allocation` | string | `"Dynamic"` | `"Dynamic"` o `"Static"`. |
| `private_ip_address` | string\|null | `null` | Requerida si `Static`. |

---

## Salidas

- `vm_id` – ID de la VM.  
- `vm_name` – Nombre de la VM.  
- `nic_id` – ID de la NIC.  
- `private_ip` – IP privada efectiva.

---

## Ejemplos

### Windows (IP dinámica)

```hcl
module "virtual_machine_web" {
  source              = "./modules/virtual_machine_marketplace"
  vm_name             = "vm-web-01"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_id           = module.vnet_simple.subnet_ids["servidores"]

  os_type       = "windows"
  vm_size       = "Standard_DS2_v2"
  security_type = "Standard"

  marketplace_image = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"      # o "2019-datacenter-g2" (Gen2)
    version   = "latest"
  }

  admin_username = var.admin_username
  admin_password = var.admin_password

  data_disks = [{ lun = 0, size_gb = 40 }]

  tags = {
    UDN="Xpertal", OWNER="Equipo Infra", xpeowner="diego@xpertal.com", proyecto="terraform", ambiente="dev"
  }
}

Windows (IP estática)


module "virtual_machine_web" {
  source              = "./modules/virtual_machine_marketplace"
  # ... comunes ...
  private_ip_allocation = "Static"
  private_ip_address    = "10.10.2.25"
  # ...
}


Linux (Ubuntu Gen2 con Trusted Launch)


module "virtual_machine_app" {
  source              = "./modules/virtual_machine_marketplace"
  vm_name             = "vm-app-01"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_id           = module.vnet_simple.subnet_ids["servidores"]

  os_type       = "linux"
  vm_size       = "Standard_DS2_v2"
  security_type = "TrustedLaunch"

  marketplace_image = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_username = "spyderadmin"
  admin_password = var.admin_password

  data_disks = [{ lun=0, size_gb=128, caching="ReadWrite", storage_account_type="Premium_LRS" }]

  tags = { UDN="Xpertal", OWNER="Infra", xpeowner="diego@xpertal.com", proyecto="terraform", ambiente="dev" }
}
