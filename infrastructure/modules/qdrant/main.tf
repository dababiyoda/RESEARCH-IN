# infrastructure/modules/qdrant/main.tf

# Configure the Qdrant provider.
# NOTE: This assumes a 'qdrant/qdrant' provider is available and configured.
# Refer to provider documentation for authentication methods.
terraform {
  required_providers {
    qdrant = {
      source = "qdrant/qdrant"
      version = "~> 1.0" # Use an appropriate version constraint
    }
  }
}

# Provision a Qdrant Cloud Cluster.
# The specific attributes like 'plan' and 'region' are conceptual based
# on common cloud provider patterns. Consult actual provider docs.
resource "qdrant_cluster" "main" {
  # A descriptive name for the cluster.
  # Using the project name ensures uniqueness within the project context.
  name = var.project_name

  # The plan determines the size and capabilities of the cluster.
  # Examples: 'dev', 'prod', 'small', 'medium', 'large'.
  plan = var.qdrant_plan

  # The cloud provider region where the cluster will be deployed.
  region = var.qdrant_region

  # Add other cluster configuration parameters here as required by the provider,
  # such as node count, cloud provider type (AWS, GCP, Azure), etc.
  # e.g., node_count = 3
  # e.g., cloud_provider = "aws"
}

# Define the 'paper_chunks' collection within the cluster.
resource "qdrant_collection" "paper_chunks" {
  # Associate the collection with the provisioned cluster.
  # The 'cluster_id' attribute is conceptual; use the actual output
  # attribute provided by the 'qdrant_cluster' resource for the cluster identifier.
  cluster_id = qdrant_cluster.main.id # Assumes 'id' attribute exists

  # The name of the collection.
  name = "paper_chunks"

  # Configure vector parameters.
  # size: The dimension of the vectors.
  # distance: The similarity metric to use (Cosine, DotProduct, Euclidean).
  vectors {
    size     = 768
    distance = "Cosine"
  }

  # HNSW (Hierarchical Navigable Small World) configuration for vector indexing.
  # This block configures the parameters for the vector index algorithm.
  # Based on typical Qdrant configurations (analogous to the structure
  # you might see in a Qdrant JSON payload example, although none was provided
  # in the reference documentation). These are sensible defaults but should be
  # tuned based on specific search performance requirements and dataset size.
  hnsw_config {
    m = 16 # The number of neighbors per node in the HNSW graph. Higher values increase index quality but also build time and memory usage.
    ef_construct = 100 # The size of the dynamic list for the nearest neighbors search during index construction. Higher values increase index quality at the cost of index build time.
    full_scan_threshold = 10000 # The number of points at which Qdrant switches from vector index to full scan for search queries.
    max_indexing_threads = 0 # Maximum number of threads to use for HNSW indexing. 0 means use all available cores.
  }

  # Optimizers configuration.
  # This block configures settings for background optimizers that manage
  # index structures and data consistency. Similar to HNSW config,
  # these are typical defaults that can be refined.
  optimizers_config {
    deleted_snapshots_limit = 5 # How many snapshots to keep before deleting old ones.
    default_segment_number = 0 # Target number of segments per shard. 0 means let Qdrant decide.
    max_segment_size = 0 # Max number of points per segment. 0 means let Qdrant decide.
    memmap_threshold = 100000 # Number of points below which segments are kept in RAM.
    indexing_threshold = 20000 # Number of points below which HNSW index is not built.
    flush_interval_sec = 5 # How often the storage flushes data to disk.
    max_optimization_threads = 0 # Maximum number of threads for optimization processes. 0 means use all available cores.
  }

  # Configure payload indexing for specific fields.
  # This allows filtering and searching based on payload values efficiently.
  payload_indexing_config {
    # Index the 'paper_id' field as a keyword. Useful for exact matches.
    index {
      field_name = "paper_id"
      field_type = "keyword"
    }

    # Index the 'chunk_index' field as an integer. Useful for range queries or sorting.
    index {
      field_name = "chunk_index"
      field_type = "integer"
    }

    # Index the 'page_numbers' field as an integer. Useful for range queries or sorting.
    index {
      field_name = "page_numbers"
      field_type = "integer"
    }

    # Add other indexes here as needed for different payload fields.
  }

  # Add other collection configuration parameters here if required by the provider,
  # such as shard_number, replication_factor, write_consistency_factor, etc.
}

# Note: This module provisions the cluster and one specific collection.
# Additional collections or data point operations must be managed
# outside of Terraform, typically using Qdrant client libraries or APIs,
# as per the project's IaC strategy.
