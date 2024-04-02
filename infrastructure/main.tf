terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}

provider "google-beta" {
  user_project_override = true
}

# Used for project creation and initializing services.
provider "google-beta" {
  alias = "no_user_project_override"
  # Disabling the user_project_override is required to enable project creation.
  # user_project_override should always be true otherwise.
  user_project_override = false
}

resource "google_project" "default" {
  provider   = google-beta.no_user_project_override
  name       = "Obsidian Share"
  project_id = var.project_id
  # Necessary to activate Blaze options on Firebase.
  billing_account = var.billing_account
  # Allow to display the project in Firebase dashboard.
  labels = {
    "firebase" = "enabled"
  }
}

resource "google_project_service" "default" {
  provider = google-beta.no_user_project_override
  project  = google_project.default.project_id
  for_each = toset([
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "firebase.googleapis.com",
    "identitytoolkit.googleapis.com",
    # Enable ServiceUsage API allow the project to be quota checked.
    "serviceusage.googleapis.com",
  ])
  service = each.key
  # Avoid service destruction if block is removed by accident.
  disable_on_destroy = false
}

resource "google_firebase_project" "default" {
  provider = google-beta
  project  = google_project.default.project_id
  # Wait for GCP project to be initialized.
  depends_on = [
    google_project_service.default
  ]
}

resource "google_identity_platform_config" "default" {
  provider = google-beta
  project  = google_project.default.project_id

  # Only configure Email/Password, no magic link.
  # Cannot add Google Sign-In because of OAuth2 limitations (interaction).
  sign_in {
    allow_duplicate_emails = false
    email {
      enabled = true
      # Disables magic link.
      password_required = true
    }
  }

  # Authorize localhost domain, should be removed from production.
  authorized_domains = [
    "localhost",
    "${google_project.default.project_id}.firebaseapp.com",
    "${google_project.default.project_id}.web.com",
  ]

  depends_on = [
    google_project_service.default
  ]
}

resource "google_firebase_web_app" "default" {
  provider     = google-beta
  project      = google_project.default.project_id
  display_name = "Obsidian Share"
  # Web app do not use DELETE by default.
  deletion_policy = "DELETE"
  # Should wait for Firebase to be enabled.
  depends_on = [
    google_firebase_project.default
  ]
}

# Allows to dump the config from Web App, to use in JS.
data "google_firebase_web_app_config" "default" {
  provider   = google-beta
  project    = google_firebase_project.default.project
  web_app_id = google_firebase_web_app.default.app_id
}
