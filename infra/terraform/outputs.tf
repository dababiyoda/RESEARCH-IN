output "supabase_url" {
  value = "https://${supabase_project.main.id}.supabase.co"
}

output "supabase_anon_key" {
  value     = data.supabase_apikeys.main.anon_key
  sensitive = true
}

output "supabase_service_role_key" {
  value     = data.supabase_apikeys.main.service_role_key
  sensitive = true
}

output "qdrant_url" {
  value = fly_app.qdrant.appurl
}

output "typesense_url" {
  value = fly_app.typesense.appurl
}

output "r2_bucket" {
  value = cloudflare_r2_bucket.pdf_cache.name
}

output "ipfs_gateway_url" {
  value = "https://${cloudflare_web3_hostname.ipfs.name}"
}
