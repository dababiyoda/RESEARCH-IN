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



# --- Module Calls ---

module "supabase_cluster" {
  source = "./modules/supabase"

  project_name = var.project_name
  region       = var.supabase_region
  db_plan      = var.supabase_db_plan
}

module "qdrant_cluster" {
  source = "./modules/qdrant"

  project_name = var.project_name
  qdrant_plan  = var.qdrant_plan
  qdrant_region = var.qdrant_region
}

module "typesense_cluster" {
  source = "./modules/typesense"

  project_name          = var.project_name
  typesense_plan        = var.typesense_plan
  typesense_region      = var.typesense_region
  typesense_cloud_api_key = var.typesense_cloud_api_key
}
