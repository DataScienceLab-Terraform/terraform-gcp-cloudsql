resource "google_compute_global_address" "private_ip_address" {
  name          = "google-managed-services"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network_id
}

resource "google_service_networking_connection" "default" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_compute_network_peering_routes_config" "peering_routes" {
  peering              = google_service_networking_connection.default.peering
  network              = var.network_name
  import_custom_routes = true
  export_custom_routes = true
}

resource "google_sql_database_instance" "default" {
  database_version = var.db_version
  name             = var.name
  region           = var.region
  root_password     = "badeend123"

  depends_on = [google_service_networking_connection.default]

  settings {
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"
    pricing_plan      = "PER_USE"
    tier              = "db-custom-1-3840"
    deletion_protection_enabled = false

    disk_autoresize       = true
    disk_autoresize_limit = 0
    disk_size             = 20
    disk_type             = "PD_SSD"

    ip_configuration {

      ipv4_enabled    = true # moet false zijn voor private ip
      private_network = var.network_id

      authorized_networks { # Moet weg bij ipv_enabled=true
        name = "Julian Thuis"
        value = "82.174.85.122/32"
      }
    }
    
    backup_configuration {
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
      enabled                        = true
      location                       = var.region
      start_time                     = "09:05"
      transaction_log_retention_days = 7
    }
    
    database_flags {
      name  = "max_connections"
      value = "400"
    }

    database_flags {
      name  = "max_prepared_transactions"
      value = "64"
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }

    insights_config {
      query_insights_enabled  = true
      query_string_length     = 2048
      record_application_tags = true
      record_client_address   = true
    }

    location_preference {
      zone = var.zone
    }

    user_labels = {
      goog-dms-instance = "true"
    }
  }
  deletion_protection = false
}


