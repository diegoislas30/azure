<!--
# 1) Blob Standard (StorageV2) privado, tier Hot
module "sa_blob_std" {
    source = "./modules/storage-account"

    rg_name  = module.resource_group.resource_group_name
    location = module.resource_group.resource_group_location

    name         = "xpeblobstd01"
    storage_type = "blob"
    performance  = "Standard"
    redundancy   = "GZRS"

    access_tier     = "Hot"
    min_tls_version = "TLS1_2"

    allow_public_network = false
    network_bypass       = ["AzureServices"]
    allowed_ip_rules     = []
    allowed_subnet_ids   = [module.vnet.subnet_ids["privadas"]] # ajusta clave

    private_endpoint_enabled              = false
    private_endpoint_subresource_name     = "blob"
    private_endpoint_subnet_id            = null
    private_endpoint_private_dns_zone_ids = []

    tags = {
        UDN      = "Xpertal"
        OWNER    = "Diego Enrique Islas Cuervo"
        xpeowner = "diegoenrique.islas@xpertal.com"
        proyecto = "terraform"
        ambiente = "dev"
    }

providers = {
        azurerm = azurerm.xpe_shared_poc
        }

}

# 2) File Premium (FileStorage) privado, con PE a "file"
module "sa_files_premium" {
    source = "./modules/storage-account"

    rg_name  = module.resource_group.resource_group_name
    location = module.resource_group.resource_group_location

    name         = "xpefilesprem01"
    storage_type = "file"
    performance  = "Premium"
    redundancy   = "ZRS"

    allow_public_network = false
    network_bypass       = ["AzureServices"]
    allowed_ip_rules     = []
    allowed_subnet_ids   = [module.vnet.subnet_ids["privadas"]]

    private_endpoint_enabled          = true
    private_endpoint_subresource_name = "file"
    private_endpoint_subnet_id        = module.vnet.subnet_ids["endpoints"]   # ajusta clave
    private_endpoint_private_dns_zone_ids = [
        azurerm_private_dns_zone.file_privatelink.id
    ]

    tags = var.tags
}

# 3) Blob Premium (BlockBlobStorage) privado
module "sa_blob_premium" {
    source = "./modules/storage-account"

    rg_name  = module.resource_group.resource_group_name
    location = module.resource_group.resource_group_location

    name         = "xpeblobprem01"
    storage_type = "blob"
    performance  = "Premium"
    redundancy   = "LRS"

    allow_public_network = false
    network_bypass       = ["AzureServices"]
    allowed_ip_rules     = []
    allowed_subnet_ids   = [module.vnet.subnet_ids["privadas"]]

    private_endpoint_enabled              = false
    private_endpoint_subresource_name     = "blob"
    private_endpoint_subnet_id            = null
    private_endpoint_private_dns_zone_ids = []

    tags = {
        ambiente = "dev"
    }
}
-->
