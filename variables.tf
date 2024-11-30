variable "azure_region" {
  description = "Azure region"
  type        = string
  default     = "East Us"
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
  default     = "mtc-resources"
}

variable "vm_name" {
  description = "Name of the Virtual Machine"
  type        = string
  default     = "mtc-vm"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "mtc-network"
}

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
  default     = "mtc-sg"
}