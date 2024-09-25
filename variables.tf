variable "ResourceGroupName" {
    type = string
    default = "Terraform-kv"
    }
  
variable "subscription_id" {
  description = "The Subscription ID where Azure resources will be created"
}

variable "client_id" {
  description = "The Client ID (Application ID) for the Service Principal"
}

variable "client_secret" {
  description = "The Client Secret for the Service Principal"
}

variable "tenant_id" {
  description = "The Tenant ID associated with your Azure Active Directory"
}

variable "keyvaultname" {
  type    = string
  default = "your-keyvault-name"
}
variable "azurerm_log_analytics_workspace_name" {
  type    = string
  default = "workspace-name"
}

variable "azurerm_mssql_server_name" {
  type    = string
  default = "mssql-server-name"
}
