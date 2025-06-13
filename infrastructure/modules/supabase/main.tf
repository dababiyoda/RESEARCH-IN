# infrastructure/modules/supabase/main.tf

# Provision the core Supabase project
resource "supabase_project" "main" {
  name   = var.project_name
  region = var.region
  plan   = var.db_plan # Attribute name for plan (e.g., 'free', 'pro') might vary slightly based on provider version/docs
}

# Note on Database Extensions (like pgvector):
# As of provider v0.1 (Alpha), enabling specific PostgreSQL extensions like pgvector
# is typically NOT supported directly via Terraform resources.
# This step must be performed manually via the Supabase UI or via SQL commands
# executed after the project is provisioned.
# Example SQL: CREATE EXTENSION IF NOT EXISTS vector;

# Configure Supabase Project Settings (including Auth)
resource "supabase_settings" "main_settings" {
  project_id = supabase_project.main.id

  # Configure Authentication Settings
  # Assuming attributes align with common auth methods
  auth_settings {
    # Enable Email and Password based sign-up and sign-in
    enable_email_signup = true
    enable_email_signin = true

    # Optional: Configure other auth settings like rate limits,
    # disallowed email domains, reauthentication interval, etc.
    # Refer to the official supabase provider documentation for available attributes.
    # e.g., disable_signup = false
  }

  # Optional: Configure Compute Instance Size if needed and supported by plan
  # compute_instance_size = "micro" # Example attribute, depends on provider version

  # Optional: Configure API Settings, Network Restrictions, etc.
  # Consult provider documentation for full list of configurable settings under supabase_settings.
}

# Provision a Supabase Storage Bucket for paper uploads
resource "supabase_storage_bucket" "paper_uploads" {
  project_id = supabase_project.main.id
  name       = "paper_uploads"
  # Configure access policy: 'public = true' for public access, 'public = false' for private.
  # Paper uploads for internal or restricted access should be private.
  public     = false

  # Note on Storage Policies:
  # Fine-grained access control (policies) for buckets is managed via
  # PostgreSQL Row Level Security (RLS) or potentially through specific
  # provider resources if available and documented. The 'public' attribute
  # on the bucket resource controls broad public read access.
}
