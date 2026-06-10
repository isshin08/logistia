variable "proxmox_api_url" {
  description = "URL de l'API Proxmox"
  type        = string
}

variable "proxmox_token_id" {
  description = "ID du token Terraform"
  type        = string
}

variable "proxmox_token_secret" {
  description = "Valeur du token Terraform"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Nom du noeud Proxmox"
  type        = string
  default     = "pve"
}

variable "template_name" {
  description = "Nom du template cloud-init"
  type        = string
  default     = "debian12-cloud"
}

variable "ssh_public_key" {
  description = "Clé SSH publique pour accéder aux VM"
  type        = string
}
