
module "vpc" {
  source       = "./modules/vpc"
  network_name = var.network_name
  region1      = var.region1
  region2      = var.region2
  region3      = var.region3
}

module "cluster1" {
  source                               = "./modules/gke-regional"
  project                              = var.project
  region                               = var.region1
  node_locations                       = var.region1_node_locations
  name                                 = var.region1_cluster_name
  node_pool_autoscaling_min_node_count = var.node_pool_autoscaling_min_node_count
  node_pool_autoscaling_max_node_count = var.node_pool_autoscaling_max_node_count
  worker_machine_type                  = var.worker_machine_type
  worker_disk_size                     = var.worker_disk_size
  worker_disk_type                     = var.worker_disk_type
  network                              = var.network_name
  subnetwork                           = module.vpc.region1_subnetwork_name
}

module "cluster2" {
  source                               = "./modules/gke-regional"
  project                              = var.project
  region                               = var.region2
  node_locations                       = var.region2_node_locations
  name                                 = var.region2_cluster_name
  node_pool_autoscaling_min_node_count = var.node_pool_autoscaling_min_node_count
  node_pool_autoscaling_max_node_count = var.node_pool_autoscaling_max_node_count
  worker_machine_type                  = var.worker_machine_type
  worker_disk_size                     = var.worker_disk_size
  worker_disk_type                     = var.worker_disk_type
  network                              = var.network_name
  subnetwork                           = module.vpc.region2_subnetwork_name
}

module "cluster3" {
  source                               = "./modules/gke-regional"
  project                              = var.project
  region                               = var.region3
  node_locations                       = var.region3_node_locations
  name                                 = var.region3_cluster_name
  node_pool_autoscaling_min_node_count = var.node_pool_autoscaling_min_node_count
  node_pool_autoscaling_max_node_count = var.node_pool_autoscaling_max_node_count
  worker_machine_type                  = var.worker_machine_type
  worker_disk_size                     = var.worker_disk_size
  worker_disk_type                     = var.worker_disk_type
  network                              = var.network_name
  subnetwork                           = module.vpc.region3_subnetwork_name
}
