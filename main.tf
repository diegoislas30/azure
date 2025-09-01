
module "resource_group1" {
  source = "./azure/modules/resource_group"
  providers = { azurerm = azurerm.xpe_shared_poc
  }
  resourece_group_name = "myResourceGroup"
  location = "East US"
  tags = {Environment = "Production", "Owner" = "TeamA"}
  
}

output "resource_group_id" {
  value = module.resource_group1.id
}


module "resource_group2" {
  source = "./azure/modules/resource_group"
  providers = { azurerm = azurerm.xpe_shared_poc
  }
  resourece_group_name = "myResourceGroup2"
  location = "East US"
  tags = {Environment = "Production", "Owner" = "TeamA"}
  
}


#