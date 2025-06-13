# --- Input Variables for Typesense Module ---

variable "project_name" {
  description = "The overall project name, used as a base for the cluster name."
  type        = string
}

variable "typesense_plan" {
  description = "The desired Typesense Cloud plan (e.g., 'dev', 'basic', 'std')."
  type        = string
}

variable "typesense_region" {
  description = "The region for the Typesense Cloud cluster deployment (e.g., 'us-east-1')."
  type        = string
}

variable "typesense_cloud_api_key" {
  description = "API key for authenticating with Typesense Cloud."
  type        = string
  sensitive   = true # Mark as sensitive to prevent printing in plan/apply outputs
}
