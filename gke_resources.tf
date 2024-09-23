# Define the GKE cluster resource
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.location

  initial_node_count       = 1
  remove_default_node_pool = true
  deletion_protection      = false
}

# Define the first node pool resource
resource "google_container_node_pool" "worker_pool_1" {
  name       = "${var.node_pool_name}-1"
  cluster    = google_container_cluster.primary.name
  location   = var.location

  node_config {
    machine_type = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_count     = var.node_count
  node_locations = [var.node_locations[0]]
}

# Define the second node pool resource
resource "google_container_node_pool" "worker_pool_2" {
  name       = "${var.node_pool_name}-2"
  cluster    = google_container_cluster.primary.name
  location   = var.location

  node_config {
    machine_type = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_count     = var.node_count
  node_locations = [var.node_locations[1]]
}
