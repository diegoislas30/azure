module "resource_group_1" {
  source              = "./modules/resource_group"
  resource_group_name = "xpeterraformpoc"
  location            = "southcentralus"

  tags = {
    UDN       = "udn-001"
    OWNER     = "diego.islas"
    xpewoner  = "equipo-xpe"
    proyecto  = "xpertal"
    ambiente  = "poc"
  }

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}


#comentario de prueba