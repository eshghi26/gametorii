provider "google" {
  project = var.project
  region  = var.region
}

# No need for a module call now
# The GKE cluster and node pools are directly defined in gke_resources.tf
# For executing
# terraform init
# terraform validate
# terraform plan -out=tfplan
# terraform apply "tfplan"
