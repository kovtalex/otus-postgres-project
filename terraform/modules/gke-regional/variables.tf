variable "project" {
  description = "GCP project ID"
}

variable "region" {
  description = "GCP region"
  default     = "europe-north1"
}

variable "node_locations" {
  type       = list
  default    = ["europe-north1-a", "europe-north1-b", "europe-north1-c"]
}

variable "name" {
  description = "Cluster name"
  default     = "cluster1"
}

variable "network" {
  default = "default"
}

variable "subnetwork" {
  default = "default"
}

variable "worker_machine_type" {
  description = "Worker node's machine type"
  type        = string
  default     = "e2-medium"
}

variable "worker_disk_size" {
  description = "Boot disk size (GB) for worker nodes"
  type        = number
  default     = 20
}

variable "worker_disk_type" {
  description = "Type of the disk attached to node"
  default     = "pd-standard"
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
