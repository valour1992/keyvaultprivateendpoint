
module "location-code" {
  source = "../location-code"
}

resource "random_string" "kv-suffix" {
  length = 10
  special = false
}

resource "azurerm_key_vault" "kv" {
  name = "KV-DEMO-${random_string.kv-suffix.result}"
  location = var.location
  resource_group_name = var.rg_name
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true
  tenant_id = var.tenant_id
  sku_name = var.kv_sku

  network_acls {
    default_action = "Deny"
    bypass = "AzureServices"
    #Uncomment below if private end point not used
    #ip_rules = var.allowed_ips
    #virtual_network_subnet_ids = var.allowed_subnets
  }
}

# Allow the SP that created the KV to write/read secrets etc

resource "azurerm_key_vault_access_policy" "cs_kvap" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.tenant_id
  object_id = var.pipeline_service_principal_object_id

  key_permissions = [
    "Get",
    "Create",
    "List",
    "Update",
  ]

  secret_permissions = [
    "Get",
    "Set",
    "List",
    "Delete",
  ]

  certificate_permissions = [
    "Get",
    "Create",
    "Update",
    "List",
    "Import",
  ]
}

# Add the User Assigned Identity to the Access Policy

resource "azurerm_key_vault_access_policy" "uai_kvap" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id = var.tenant_id
  object_id = var.uai_id

  secret_permissions = [
    "Get",
    "Set",
    "List",
    "Delete",
  ]
}

# Allow KubeOperations support group to manage the keys

resource "azurerm_key_vault_access_policy" "admin_kvap" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.tenant_id
  object_id = var.admin_group_id

  key_permissions = [
    "Get",
    "Create",
    "List",
    "Update",
  ]

  secret_permissions = [
    "Get",
    "Set",
    "List",
    "Delete",
  ]

  certificate_permissions = [
    "Get",
    "Create",
    "Update",
    "List",
    "Import",
  ]
}

resource "azurerm_private_endpoint" "demo" {
    name                = "demo-endpoint"
    location            = "australiaeast"
    resource_group_name = var.rg_name
    subnet_id           = var.subnet_id

    private_service_connection {
        name                           = "demo-privateserviceconnection"
        private_connection_resource_id = azurerm_key_vault.kv.id
        is_manual_connection           = false
        subresource_names              = ["vault"]
    }
}