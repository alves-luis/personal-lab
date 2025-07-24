output "bucket_endpoint" {
  value       = scaleway_object_bucket.truenas_backup.endpoint
  description = "The endpoint URL of the TrueNAS backup bucket."
}

output "bucket_region" {
  value       = scaleway_object_bucket.truenas_backup.region
  description = "The region where the TrueNAS backup bucket is located."
}
