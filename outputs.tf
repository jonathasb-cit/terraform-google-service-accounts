/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "service_account" {
  description = "Service account resource (for single use)."
  value       = google_service_account.service_accounts[0]
}

output "email" {
  description = "Service account email (for single use)."
  value       = google_service_account.service_accounts[0].email
}

output "iam_email" {
  description = "IAM-format service account email (for single use)."
  value       = "serviceAccount:${google_service_account.service_accounts[0].email}"
}

output "key" {
  description = "Service account key (for single use)."
  value       = data.template_file.keys[0].rendered
}

output "service_accounts" {
  description = "Service account resources."
  value       = google_service_account.service_accounts
}

output "emails" {
  description = "Service account emails."
  value       = zipmap(var.names, google_service_account.service_accounts[*].email)
}

output "iam_emails" {
  description = "IAM-format service account emails."
  value       = zipmap(var.names, local.iam_emails)
}

output "emails_list" {
  description = "Service account emails."
  value       = google_service_account.service_accounts[*].email
}

output "iam_emails_list" {
  description = "IAM-format service account emails."
  value       = [for s in google_service_account.service_accounts : "serviceAccount:${s.email}"]
}

data "template_file" "keys" {
  count    = length(var.names)
  template = "$${key}"

  vars = {
    key = var.generate_keys ? var.private_key_type == "TYPE_GOOGLE_CREDENTIALS_FILE" ? base64decode(google_service_account_key.keys[count.index].private_key) : google_service_account_key.keys[count.index].private_key : ""
  }
}

output "keys" {
  description = "Map of service account keys."
  sensitive   = true
  value       = zipmap(var.names, data.template_file.keys[*].rendered)
}
