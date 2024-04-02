# Describe the config to include in frontend.
output "config" {
  value = jsonencode(data.google_firebase_web_app_config.default)
}
