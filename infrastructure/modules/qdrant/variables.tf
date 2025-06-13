# Variables for configuring the Qdrant Cloud infrastructure module.

# Variable for the overall project name.
# Used to name resources and ensure uniqueness.
variable "project_name" {
  description = "The name of the project. Used for resource naming."
  type        = string
}

# Variable for the Qdrant Cloud cluster plan.
# This determines the size and tier of the cluster.
variable "qdrant_plan" {
  description = "The plan/size for the Qdrant Cloud cluster (e.g., 'dev', 'prod')."
  type        = string
}

# Variable for the Qdrant Cloud cluster region.
# Specifies the geographical region for deployment.
variable "qdrant_region" {
  description = "The cloud provider region for the Qdrant Cloud cluster."
  type        = string
}

# Add other variables here for any additional configurable parameters
# of the Qdrant cluster resource used in main.tf (e.g., node count, cloud provider type).
