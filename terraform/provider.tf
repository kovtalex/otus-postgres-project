provider "google-beta" {
  project = var.project
  region  = var.region1
}

provider "google" {
  project = var.project
  region  = var.region1
}
