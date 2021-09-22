terraform {
  backend "gcs" {
    bucket = "postgres-tfstate"
    prefix = "terraform/state"
  }
}
