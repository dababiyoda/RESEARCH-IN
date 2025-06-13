# --- Output Values ---

output "supabase_api_url" {
  description = "The API URL for the Supabase project."
  value       = module.supabase_cluster.api_url
}

output "supabase_anon_key" {
  description = "The anonymous public key for the Supabase project."
  value       = module.supabase_cluster.anon_key
  sensitive   = true
}

output "qdrant_cluster_url" {
  description = "The URL for the Qdrant Cloud cluster endpoint."
  value       = module.qdrant_cluster.qdrant_cluster_url
}

output "qdrant_api_key" {
  description = "The API key for the Qdrant Cloud cluster."
  value       = module.qdrant_cluster.qdrant_api_key
  sensitive   = true
}

output "typesense_cluster_host" {
  description = "The host address for the Typesense Cloud cluster."
  value       = module.typesense_cluster.typesense_cluster_host
}

output "typesense_api_key" {
  description = "The API key for the Typesense Cloud cluster."
  value       = module.typesense_cluster.typesense_api_key
  sensitive   = true
}

