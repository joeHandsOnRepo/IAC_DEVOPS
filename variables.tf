variable "ResourceGroupName" {
    type = string
    default = "IAC-VM-FN"
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

