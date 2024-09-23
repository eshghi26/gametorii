variable "project" {
  description = "The project ID where resources will be created."
  type        = string
}

variable "region" {
  description = "The region where resources will be created."
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
}

variable "location" {
  description = "The location (zone) of the GKE cluster."
  type        = string
}

variable "node_pool_name" {
  description = "The name prefix for the node pools."
  type        = string
}

variable "node_count" {
  description = "The number of nodes in each node pool."
  type        = number
}

variable "machine_type" {
  description = "The machine type for the worker nodes."
  type        = string
}

variable "node_locations" {
  description = "The list of zones where the node pools should be deployed."
  type        = list(string)
}
