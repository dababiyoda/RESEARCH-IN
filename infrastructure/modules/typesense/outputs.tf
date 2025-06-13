# --- Output Values for Typesense Module ---

output "typesense_cluster_host" {
  description = "The host address for the Typesense Cloud cluster endpoint."
  # The 'host' attribute is typically available on the cluster resource
  value = typesense_cluster.main.host
}

output "typesense_api_key" {
  description = "The API key used to connect to the Typesense Cloud cluster."
  # The Typesense provider does not expose the cluster's auto-generated
  # API key via the typesense_cluster resource. A common pattern is to
  # output the *input* API key that was used to provision/manage the cluster,
  # as this key is often the master key or an administrative key needed
  # for subsequent operations (like creating collections).
  value     = var.typesense_cloud_api_key
  sensitive = true # Mark as sensitive
}
