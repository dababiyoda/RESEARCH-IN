# --- Terraform Configuration ---
terraform {
  # Configure remote state management using Terraform Cloud
  cloud {
    organization = "open-research-nexus-org" # Replace with your organization name

    # Optional: Specify a workspace name
    # workspace {
    #   name = "open-research-nexus-dev"
    # }
  }

  # Declare required providers and their versions
  required_providers {
    # Supabase provider (official, Public Alpha)
    supabase = {
      source  = "supabase/supabase"
      version = "~> 0.1" # Use appropriate version constraint
    }

    # Qdrant Cloud provider (official, stable)
    qdrant = {
      source  = "qdrant/qdrant-cloud"
      version = "~> 1.0" # Use appropriate version constraint
    }

    # Typesense provider (community, for cluster management)
    typesense = {
      source  = "CookiesCo/typesense"
      version = "~> 0.1" # Use appropriate version constraint
    }
  }

  # Specify required Terraform version
  required_version = ">= 1.0"
}

# --- Provider Configuration ---
# Configure Supabase provider (uses environment variables for authentication)
# Learn more: https://registry.terraform.io/providers/supabase/supabase/latest/docs
provider "supabase" {
  # Configuration details (e.g., API key) are typically handled via
  # environment variables or configuration files external to the main HCL.
}

# Configure Qdrant Cloud provider using the API key variable
# Learn more: https://registry.terraform.io/providers/qdrant/qdrant-cloud/latest/docs
provider "qdrant" {
  api_key = var.qdrant_cloud_api_key
}

# Configure Typesense provider using the API key variable
# Learn more: https://registry.terraform.io/providers/CookiesCo/typesense/latest/docs
provider "typesense" {
  api_key = var.typesense_cloud_api_key
  # host = "cloud.typesense.com" # Provider may automatically use cloud endpoint
}


# --- Module Calls (Placeholders) ---
# TODO: Develop and call dedicated modules for each service cluster.
# These modules will encapsulate the resource definitions for each component.

# Provision Supabase Project and initial configuration
# module "supabase_cluster" {
#   source = "./modules/supabase_cluster" # Path to your Supabase module
#
#   project_name    = var.project_name
#   project_id      = var.supabase_project_id # May not be needed for creation, depends on provider resource
#   cloud_provider  = var.supabase_cloud_provider
#   region          = var.supabase_region
#   # ... other configurations from variables or locals
# }

# Provision Qdrant Cloud Cluster
# module "qdrant_cluster" {
#   source = "./modules/qdrant_cluster" # Path to your Qdrant module
#
#   api_key = var.qdrant_cloud_api_key # Pass sensitive key if needed by module
#   # ... other Qdrant specific configurations
# }

# Provision Typesense Cloud Cluster
# module "typesense_cluster" {
#   source = "./modules/typesense_cluster" # Path to your Typesense module
#
#   api_key = var.typesense_cloud_api_key # Pass sensitive key if needed by module
#   # ... other Typesense specific configurations
# }
