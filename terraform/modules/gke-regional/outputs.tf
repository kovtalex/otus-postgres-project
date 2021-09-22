output "cluster_endpoint" {
  description = "Public endpoint of Kubernetes cluster"
  value       = google_container_cluster.cluster.endpoint
}
