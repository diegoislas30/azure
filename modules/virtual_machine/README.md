# virtual_machine_sig

Módulo de Terraform para crear **máquinas virtuales de Azure** usando **Shared Image Gallery (SIG)** o **Managed Image** mediante `source_image_id`.  
Incluye **Trusted Launch** opcional, **OS disk** parametrizable, **data disks** gestionados con attachments y **IP privada dinámica o estática**.  
> Sin IP pública y sin NSG en la NIC/VM (se asume NSG a nivel **subnet**).

---

## Características

- VM **Linux** o **Windows** (`os_type`).
- Imagen desde **SIG** (ID ARM de **versión**) o **Managed Image** (`source_image_id`).
- **Trusted Launch** (si la imagen es **Gen2**).
- **IP privada** dinámica o estática.
- **OS Disk** y **Data Disks** configurables (SKU, tamaño, caching).
- **Availability Zone** opcional (`zone`).
- **Accelerated Networking** opcional.
- **Tags** obligatorios (objeto con 5 claves).

---

## Requisitos

- Provider `azurerm` ≥ **3.116** (probado con 3.117.x).
- Permisos para crear VMs, NICs y Discos en la suscripción destino.
- Si la imagen SIG está en **otra suscripción**:
  - Concede **Reader** al Service Principal en el scope de la **galería / imagen / versión**.
  - La **versión** debe estar **replicada en la región** de la VM.

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
| `source_image_id` | string | – | **ID ARM de la versión SIG** (termina en `/versions/x.y.z`) o Managed Image. |
| `admin_username` | string | `"spyderadmin"` | Usuario admin. |
| `admin_password` | string (sens.) | – | Contraseña admin. |
| `os_disk_size_gb` | number | `128` | Tamaño OS disk. |
| `os_disk_storage_account_type` | string | `"StandardSSD_LRS"` | SKU OS disk. |
| `os_disk_caching` | string\|null | `null` → RW | `None` / `ReadOnly` / `ReadWrite`. |
| `data_disks` | list(object) | `[]` | `[{ lun, size_gb, caching?, storage_account_type? }]`. |
| `enable_accelerated_networking` | bool | `false` | NIC Accelerated Networking. |
| `boot_diagnostics_storage_uri` | string\|null | `null` | URI de Storage para boot diagnostics. |
| `tags` | object | – | `{ UDN, OWNER, xpeowner, proyecto, ambiente }`. |
| `private_ip_version` | string | `"IPv4"` | `"IPv4"` o `"IPv6"`. |
| `private_ip_allocation` | string | `"Dynamic"` | `"Dynamic"` o `"Static"`. |
| `private_ip_address` | string\|null | `null` | Requerida si `private_ip_allocation = "Static"`. |

---

## Salidas

- `vm_id` – ID de la VM.  
- `vm_name` – Nombre de la VM.  
- `nic_id` – ID de la NIC.  
- `private_ip` – IP privada efectiva.

---

## Ejemplos

### 1) Windows desde **SIG** (Gen1 → `security_type = "Standard"`)

```hcl
module "virtual_machine_web" {
  source              = "./modules/virtual_machine_sig"
  vm_name             = "vm-web-01"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_id           = module.vnet_simple.subnet_ids["servidores"]

  os_type       = "windows"
  vm_size       = "Standard_DS2_v2"
  security_type = "Standard"  # usa TrustedLaunch solo si la imagen es Gen2

  # ID de la VERSIÓN SIG (termina en /versions/x.y.z)
  source_image_id = "/subscriptions/<subSIG>/resourceGroups/<rg>/providers/Microsoft.Compute/galleries/<gallery>/images/<image>/versions/1.0.3"

  admin_username = var.admin_username
  admin_password = var.admin_password

  data_disks = [{ lun = 0, size_gb = 40 }]

  tags = {
    UDN="Xpertal", OWNER="Equipo Infra", xpeowner="diego@xpertal.com", proyecto="terraform", ambiente="dev"
  }
}

2) IP privada estática

module "virtual_machine_web" {
  source                = "./modules/virtual_machine_sig"
  # ... parámetros comunes ...

  private_ip_allocation = "Static"
  private_ip_address    = "10.10.2.25"  # dentro del CIDR de la subnet

  # ...
}

3) Linux desde Managed Image (Gen2 → security_type = "TrustedLaunch")

module "virtual_machine_app" {
  source              = "./modules/virtual_machine_sig"
  vm_name             = "vm-app-01"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  subnet_id           = module.vnet_simple.subnet_ids["servidores"]

  os_type       = "linux"
  vm_size       = "Standard_DS2_v2"
  security_type = "TrustedLaunch"

  source_image_id = "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Compute/images/myManagedImageGen2"

  admin_username = "spyderadmin"
  admin_password = var.admin_password

  data_disks = [
    { lun = 0, size_gb = 128, caching = "ReadWrite", storage_account_type = "Premium_LRS" }
  ]

  tags = { UDN="Xpertal", OWNER="Infra", xpeowner="diego@xpertal.com", proyecto="terraform", ambiente="dev" }
}
