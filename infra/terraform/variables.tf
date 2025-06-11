variable "supabase_access_token" {
  description = "Supabase personal access token"
  type        = string
  sensitive   = true
}

variable "supabase_organization_id" {
  description = "Supabase organization ID"
  type        = string
}

variable "supabase_project_name" {
  description = "Supabase project name"
  type        = string
  default     = "research-in"
}

variable "supabase_db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "supabase_region" {
  description = "Supabase region"
  type        = string
  default     = "us-east-1"
}

variable "supabase_instance_size" {
  description = "Supabase instance size"
  type        = string
  default     = "small"
}

variable "fly_access_token" {
  description = "Fly.io access token"
  type        = string
  sensitive   = true
}

variable "fly_org" {
  description = "Fly.io organization slug"
  type        = string
}

variable "qdrant_app_name" {
  description = "Fly.io app name for Qdrant"
  type        = string
  default     = "qdrant"
}

variable "qdrant_region" {
  description = "Fly.io region for Qdrant"
  type        = string
  default     = "iad"
}

variable "qdrant_image" {
  description = "Docker image for Qdrant"
  type        = string
  default     = "qdrant/qdrant:latest"
}

variable "qdrant_volume_size" {
  description = "Volume size in GB for Qdrant"
  type        = number
  default     = 10
}

variable "typesense_app_name" {
  description = "Fly.io app name for Typesense"
  type        = string
  default     = "typesense"
}

variable "typesense_region" {
  description = "Fly.io region for Typesense"
  type        = string
  default     = "iad"
}

variable "typesense_image" {
  description = "Docker image for Typesense"
  type        = string
  default     = "typesense/typesense:latest"
}

variable "typesense_volume_size" {
  description = "Volume size in GB for Typesense"
  type        = number
  default     = 10
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for IPFS gateway"
  type        = string
}

variable "ipfs_gateway_domain" {
  description = "Domain name for IPFS gateway"
  type        = string
  default     = "ipfs.example.com"
}

variable "r2_location" {
  description = "Cloudflare R2 bucket location hint"
  type        = string
  default     = "ENAM"
}

variable "ipfs_dnslink" {
  description = "DNSLink value for the IPFS gateway"
  type        = string
  default     = null
}
