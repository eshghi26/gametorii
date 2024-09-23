provider "google" {
  project = var.project
  region  = var.region
}

module "gke_cluster" {
  source = "./gc_module"

  cluster_name   = var.cluster_name
  location       = var.location
  node_pool_name = var.node_pool_name
  node_count     = var.node_count
  machine_type   = var.machine_type
  node_locations = var.node_locations
}
