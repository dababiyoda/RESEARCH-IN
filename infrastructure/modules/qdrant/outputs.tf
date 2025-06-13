# Outputs for the Qdrant Cloud infrastructure module.

# Output the URL endpoint for the provisioned Qdrant cluster.
# This URL is used by clients to connect to the cluster.
output "qdrant_cluster_url" {
  description = "The URL endpoint for the Qdrant cluster."
  # Assumes the 'qdrant_cluster' resource exposes a 'cluster_url' attribute.
  value       = qdrant_cluster.main.cluster_url # Update attribute name if necessary
}

# Output the API key for authenticating with the Qdrant cluster.
# Mark this output as sensitive to prevent it from being displayed
# in plain text during 'terraform apply' or 'terraform output'.
output "qdrant_api_key" {
  description = "The API key for authenticating with the Qdrant cluster."
  # Assumes the 'qdrant_cluster' resource exposes an 'api_key' attribute
  # or that a separate resource for API keys provides it.
  value     = qdrant_cluster.main.api_key # Update attribute name if necessary
  sensitive = true
}

# Add other outputs here if needed, such as cluster ID, region, etc.
