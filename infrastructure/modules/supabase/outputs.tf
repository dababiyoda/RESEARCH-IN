# infrastructure/modules/supabase/outputs.tf

# --- Supabase Module Output Values ---

output "project_id" {
  description = "The ID of the deployed Supabase project."
  value       = supabase_project.main.id
}

output "api_url" {
  description = "The API URL for the Supabase project."
  # Assuming 'api_url' is an output attribute of the supabase_project resource
  value       = supabase_project.main.api_url
}

output "anon_key" {
  description = "The anonymous public key (anon key) for the Supabase project."
  # Assuming 'anon_key' is an output attribute of the supabase_project resource
  value       = supabase_project.main.anon_key
  sensitive   = true # Mark as sensitive to prevent printing in logs
}

output "service_role_key" {
  description = "The service role key for the Supabase project."
  # Assuming 'service_role_key' is an output attribute of the supabase_project resource
  value       = supabase_project.main.service_role_key
  sensitive   = true # Mark as sensitive to prevent printing in logs
}
