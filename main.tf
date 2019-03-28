resource "google_container_cluster" "gke_cluster" {
  name = "team-cluster-${var.environment_short}"
  project = "${var.project_id}"
  region = "${var.region}"

  // This entry is for v2 of the Stackdriver Logging/Monitoring Service
  logging_service = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  // Regional clusters will replicate nodes across all zones
  // resulting in a total of 3 nodes
  initial_node_count = 1

  // Maintenance window set to 1am AEST
  maintenance_policy {
    daily_maintenance_window {
      // This is UTC
      start_time = "15:00"
    }
  }

  master_authorized_networks_config {
    cidr_blocks = [
      {
        // CIDR Block for TW WiFi
        display_name = "office"
        cidr_block = "210.9.145.36/30"
      }
    ]
  }
}

resource "google_cloudbuild_trigger" "build_application" {
  project = "${var.project_id}"
  provider = "google-beta"
  trigger_template {
    branch_name = "master"
    repo_name = "${var.application_repo_name}"
  }
  filename = "cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "deploy_application" {
  project = "${var.project_id}"
  provider = "google-beta"
  trigger_template {
    branch_name = "master"
    repo_name = "github_paulvalla_tw-in-a-box-gke-application-env"
  }
  filename = "cloudbuild.yaml"
}
