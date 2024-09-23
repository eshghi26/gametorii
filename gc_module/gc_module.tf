resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.location

  # Cluster-level settings
  initial_node_count = 1

  # Remove the default node pool
  remove_default_node_pool = true
  deletion_protection       = false
}

# Worker pool 1
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

# Worker pool 2
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
