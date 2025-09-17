module "resource_group_xpeterraformpoc" {
  source = "./modules/resource_group"

  resource_group_name = "xpeterraformpoc-rg"
  location            = "southcentralus"
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


## Recurso generado por Yam


module "resource_group_xpeterraformpoc2" {
  source = "./modules/resource_group"

  resource_group_name = "xpeterraformpoc2-rg"
  location            = "southcentralus"
  tags = {
    UDN      = "Xpertal"
    OWNER    = "Guillermo Yam"
    xpeowner = "guillermo.yam@xpertal.com"
    proyecto = "terraform"
    ambiente = "dev"
  }

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}

## Recurso generado pedro 


module "resource_group_xpeterraformpoc3" {
  source = "./modules/resource_group"

  resource_group_name = "xpeterraformpoc3-rg"
  location            = "southcentralus"
  tags = {
    UDN      = "Xpertal"
    OWNER    = "Pedro Guerrero"
    xpeowner = "pedrojulio.guerrero@xpertal.com"
    proyecto = "terraform"
    ambiente = "QA"
  }

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}


# Módulo si para crear la red virtual "simple" principal del proyecto xpterraformpoc.
# Utiliza el grupo de recursos creado por el módulo resource_group_xpeterraformpoc.
# Define el espacio de direcciones y tres subredes: apps, db y web.
# Aplica etiquetas para identificar el propietario, proyecto y ambiente.
# module "vnet_xpterraformpoc" {
#   source              = "./modules/vnets"
#   resource_group_name = module.resource_group_xpeterraformpoc.resource_group_name
#   location            = module.resource_group_xpeterraformpoc.resource_group_location
#   vnet_name           = "xpterraformpoc-vnet"
#   address_space       = ["20.0.0.0/16"]
#
#   subnets = [
#     { name = "subnet-apps", address_prefix = "20.0.10.0/24" },
#     { name = "subnet-db",   address_prefix = "20.0.20.0/24" },
#     { name = "subnet-web",  address_prefix = "20.0.30.0/24" }
#   ]
#
#   tags = {
#     UDN      = "Xpertal"
#     OWNER    = "Diego Enrique Islas Cuervo"
#     xpeowner = "dislas@caabsa.com.mx"
#     proyecto = "terraform"
#     ambiente = "dev"
#   }
#
#   providers = {
#     azurerm = azurerm.xpe_shared_poc
#   }
# }



/*
  Módulo: network_security_group

  Este módulo crea un Grupo de Seguridad de Red (NSG) de Azure con reglas de seguridad personalizadas.

  Parámetros:
    - nsg_name: Nombre del Grupo de Seguridad de Red.
    - location: Región de Azure donde se implementará el NSG. Derivado del módulo de grupo de recursos.
    - resource_group_name: Nombre del grupo de recursos asociado al NSG. Derivado del módulo de grupo de recursos.
    - security_rules: Lista de reglas de seguridad que se aplicarán al NSG. Cada regla incluye:
        - name: Nombre de la regla (ejemplo: "Allow-HTTP", "Allow-HTTPS", "Deny-All-Inbound").
        - priority: Prioridad de la regla (número menor = mayor prioridad).
        - direction: "Inbound" o "Outbound".
        - access: "Allow" o "Deny".
        - protocol: Tipo de protocolo (ejemplo: "Tcp", "*").
        - source_port_range: Rango de puertos de origen (ejemplo: "*").
        - destination_port_range: Rango de puertos de destino (ejemplo: "80", "443", "*").
        - source_address_prefix: Prefijo de dirección de origen (ejemplo: "*").
        - destination_address_prefix: Prefijo de dirección de destino (ejemplo: "*").
    - tags: Pares clave-valor para etiquetado de recursos (ejemplo: propietario, proyecto, ambiente).
    - providers: Especifica la instancia del proveedor azurerm a utilizar.

*/

module "network_security_group" {
  source = "./modules/network_security_group"

  nsg_name             = "xpterraformpoc-nsg"
  location             = module.resource_group_xpeterraformpoc.resource_group_location
  resource_group_name  = module.resource_group_xpeterraformpoc.resource_group_name
  security_rules       = [
    {
      name                        = "Allow-HTTP"
      priority                    = 100
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "80"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    },
    {
      name                        = "Allow-HTTPS"
      priority                    = 110
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "443"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    },
    {
      name                        = "Deny-All-Inbound"
      priority                    = 4096
      direction                   = "Inbound"
      access                      = "Deny"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "*"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    }
  ]

  tags = {
    UDN      = "Xpertal"
    OWNER    = "Diego Enrique Islas Cuervo"
    xpeowner = "dislas@caabsa.com.mx"
    proyecto = "terraform"
    ambiente = "dev"
  }

  providers = {
    azurerm = azurerm.xpe_shared_poc
  }
}


module "vnet_xpterraformpoc" {
  source              = "./modules/vnets"
  resource_group_name = module.resource_group_xpeterraformpoc.resource_group_name
  location            = module.resource_group_xpeterraformpoc.resource_group_location
  vnet_name           = "xpterraformpoc-vnet"
  address_space       = ["20.0.0.0/16"]
  nsg_id              = module.network_security_group.nsg_id

  subnets = [
    { name = "subnet-apps", address_prefix = "20.0.10.0/24" },
    { name = "subnet-db",   address_prefix = "20.0.20.0/24" },
    { name = "subnet-web",  address_prefix = "20.0.30.0/24" }
  ]

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

## veamos si con esto funciona

 
