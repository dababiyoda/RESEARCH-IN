# --- Typesense Module Configuration ---

# Configure the community Typesense provider for Typesense Cloud
# This provider manages the cluster itself.
# Note: Configuration details like the API key are typically passed down
# from the root module or handled via environment variables where the
# provider block is defined. We configure it here to use the input variable.
provider "typesense" {
  api_key = var.typesense_cloud_api_key
  # host = "cloud.typesense.com" # Provider may automatically use cloud endpoint
}

# Define the Typesense Cloud Cluster resource
# This provisions the core Typesense service instance.
resource "typesense_cluster" "main" {
  # The name of the cluster. Uses project_name by default.
  name = var.project_name != "open-research-nexus" ? "${var.project_name}-typesense" : "open-research-nexus-typesense"

  # The plan/size of the cluster (e.g., 'dev', 'basic', 'std').
  plan = var.typesense_plan

  # The region where the cluster should be deployed (e.g., 'us-east-1').
  region = var.typesense_region

  # Optional: Enable high availability.
  # high_availability = true # Uncomment and set based on your needs and plan

  # Optional: Enable auto upgrade.
  # auto_upgrade_capacity = true # Uncomment based on your preference

  # Other potential arguments might be available depending on provider version
  # and Typesense Cloud offerings. Refer to provider documentation.
}

# --- Collection Management (Requires Alternative Approach) ---

# IMPORTANT: The community 'typesense' provider (CookiesCo/typesense)
# DOES NOT support creating or managing 'typesense_collection' resources.
# This resource type is not implemented in the provider.

# Collection schema definition and creation must be handled OUTSIDE
# this specific provider, typically using:
# 1. Terraform's 'http' provider to call the Typesense Management API directly.
# 2. 'local-exec' provisioners to run Typesense CLI commands or custom scripts.
# 3. Client libraries from your application code after deployment.

# The schema definitions below are based on the project plan's requirements
# but cannot be managed by the 'typesense_cluster' provider resource here.
# They are included as comments for reference to the required collection structure.

/*
# Desired 'papers' collection schema (for reference only - NOT managed by this provider)
resource "typesense_collection" "papers" {
  name = "papers"
  fields = [
    {
      name  = "title"
      type  = "string"
      index = true
    },
    {
      name  = "abstract"
      type  = "string"
      index = true
    },
    {
      name  = "authors"
      type  = "string[]" # Array of strings for multiple authors
      index = true
      facet = true # Often useful for filtering/faceting by author
    },
    {
      name  = "publication_date"
      type  = "int64" # Use int64 for Unix timestamp for range queries
      index = true
      sort  = true # Enable sorting by date
    },
    {
      name  = "doi"
      type  = "string"
      index = true # Index for exact match lookup
    },
    {
      name  = "source_type" # e.g., "journal-article", "conference-paper"
      type  = "string"
      index = true
      facet = true # Enable faceting by source type
    }
  ]
  default_sorting_field = "publication_date" # Default sort by date
}

# Desired 'research_questions' collection schema (for reference only - NOT managed by this provider)
resource "typesense_collection" "research_questions" {
  name = "research_questions"
  fields = [
    {
      name  = "title"
      type  = "string"
      index = true
    },
    {
      name  = "description"
      type  = "string"
      index = true
    }
  ]
}
*/
