variable "project" {
  description = "GCP project ID"
  type        = string
}

variable "region1_cluster_name" {
  default = "tf-region1"
}

variable "region2_cluster_name" {
  default = "tf-region2"
}

variable "region3_cluster_name" {
  default = "tf-region3"
}

variable "region1" {
  default = "europe-north1"
}

variable "region2" {
  default = "europe-west1"
}

variable "region3" {
  default = "europe-central2"
}

variable "region1_node_locations" {
  type    = list(any)
  default = ["europe-north1-a", "europe-north1-b", "europe-north1-c"]
}

variable "region2_node_locations" {
  type    = list(any)
  default = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
}

variable "region3_node_locations" {
  type    = list(any)
  default = ["europe-central2-a", "europe-central2-b", "europe-central2-c"]
}

variable "network_name" {
  default = "tf-gke-multi-region"
}

variable "worker_machine_type" {
  description = "Worker node's machine type"
  type        = string
  default     = "e2-medium"
}

variable "worker_disk_size" {
  description = "Boot disk size (GB) for worker nodes"
  type        = number
  default     = 10
}

variable "worker_disk_type" {
  description = "Type of the disk attached to node"
  default     = "pd-ssd"
}

variable "node_pool_autoscaling_min_node_count" {
  description = "Minimum nodes in cluster = value * availability zones count"
  type        = number
  default     = 1
}

variable "node_pool_autoscaling_max_node_count" {
  description = "Maximum nodes in cluster = value * availability zones count"
  type        = number
  default     = 1
}
