# infrastructure/modules/supabase/variables.tf

# --- Supabase Module Input Variables ---

variable "project_name" {
  description = "A unique name for the Supabase project."
  type        = string
}

variable "region" {
  description = "The region for the Supabase project (e.g., 'us-east-1', 'eu-central-1')."
  type        = string
}

variable "db_plan" {
  description = "The database plan for the Supabase project (e.g., 'free', 'pro')."
  type        = string
  # Add validation if specific plan slugs are required and known
  # validation {
  #   condition     = contains(["free", "pro", "team"], var.db_plan)
  #   error_message = "Invalid Supabase database plan specified. Must be one of: free, pro, team."
  # }
}

# Note: Supabase provider typically authenticates via environment variables
# like SUPABASE_ACCESS_TOKEN or configuration file, not variables passed into the module.
