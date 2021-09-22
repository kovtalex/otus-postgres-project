resource "google_compute_network" "default" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "region1" {
  name          = var.network_name
  ip_cidr_range = "10.126.0.0/20"
  network       = google_compute_network.default.self_link
  region        = var.region1
}

resource "google_compute_subnetwork" "region2" {
  name          = var.network_name
  ip_cidr_range = "10.127.0.0/20"
  network       = google_compute_network.default.self_link
  region        = var.region2
}

resource "google_compute_subnetwork" "region3" {
  name          = var.network_name
  ip_cidr_range = "10.128.0.0/20"
  network       = google_compute_network.default.self_link
  region        = var.region3
}

resource "google_compute_firewall" "internal" {
  name    = "allow-cockroach-internal"
  network = google_compute_network.default.self_link

  allow {
    protocol = "tcp"
    ports    = ["26257"]
  }

  source_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

resource "google_compute_firewall" "external" {
  name    = "allow-cockroach-external"
  network = google_compute_network.default.self_link

  allow {
    protocol = "tcp"
    ports    = ["30001", "30002"]
  }

  source_ranges = ["0.0.0.0/0"]
}
