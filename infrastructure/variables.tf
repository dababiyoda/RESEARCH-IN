# --- Input Variables ---

# Generic Project Name
variable "project_name" {
  description = "A unique name for the Open-Research Nexus project."
  type        = string
  default     = "open-research-nexus"
}

# Supabase Configuration Variables
variable "supabase_project_id" {
  description = "The ID for the Supabase project. May be needed for referencing or creating."
  type        = string
  # validation {
  #   condition     = length(var.supabase_project_id) > 0
  #   error_message = "The Supabase project ID must not be empty."
  # }
  # Note: Depending on the resource, this might be optional for creation
  # or derived differently. Adjust description/validation as needed.
}

variable "supabase_cloud_provider" {
  description = "The cloud provider for the Supabase project (e.g., 'AWS')."
  type        = string
  # validation {
  #   condition     = contains(["AWS", "GCP", "Azure"], var.supabase_cloud_provider) # Example validation
  #   error_message = "Invalid Supabase cloud provider specified. Must be one of: AWS, GCP, Azure."
  # }
}

variable "supabase_region" {
  description = "The region for the Supabase project (e.g., 'us-east-1')."
  type        = string
}

variable "supabase_db_plan" {
  description = "Plan for the Supabase database (e.g., 'free')."
  type        = string
  default     = "free"
}

# Qdrant Cloud Configuration Variables
variable "qdrant_cloud_api_key" {
  description = "API key for authenticating with Qdrant Cloud."
  type        = string
  sensitive   = true # Mark as sensitive to prevent printing in plan/apply outputs
}

variable "qdrant_plan" {
  description = "Plan for the Qdrant cluster"
  type        = string
  default     = "starter"
}

variable "qdrant_region" {
  description = "Region for the Qdrant cluster"
  type        = string
  default     = "us-east-1"
}

# Typesense Cloud Configuration Variables
variable "typesense_cloud_api_key" {
  description = "API key for authenticating with Typesense Cloud."
  type        = string
  sensitive   = true # Mark as sensitive to prevent printing in plan/apply outputs
}

variable "typesense_plan" {
  description = "Plan for the Typesense cluster"
  type        = string
  default     = "starter"
}

variable "typesense_region" {
  description = "Region for the Typesense cluster"
  type        = string
  default     = "us-east-1"
}
