variable "tenant_id" {
  type = string
}

variable "location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "allowed_ips" {
  description = "restrict access to only these ips"
  default     = []
  type        = list(string)
}

variable "allowed_subnets" {
  description = "a list of subnets to allow access to keyvault through service endpointing"
  default     = []
}

variable "pipeline_service_principal_object_id" {
  description = "Needed to allow the product home SPN to interact with the KV secrets"
  type = string
}

#variable "kube_ad_server_application_secret" {
#  type = string
#}

#variable "tags" {
#  type = map(any)
#}

variable "kv_sku" {
  type    = string
  default = "standard"
}

variable "uai_id" {
  type = string
}

variable "admin_group_id" {
  type = string
}

variable "subnet_id" {
  type = string
}