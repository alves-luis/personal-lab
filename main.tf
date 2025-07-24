resource "scaleway_iam_application" "truenas" {
  name            = "TrueNAS"
  description     = "Application for TrueNAS to access Scaleway resources."
  organization_id = var.organization_id
}

resource "scaleway_iam_policy" "truenas_manage_s3" {
  name            = "TrueNAS S3 Management Policy"
  description     = "Gives TrueNAS permissions to upload/download objects in the S3 bucket."
  application_id  = scaleway_iam_application.truenas.id
  organization_id = var.organization_id
  rule {
    project_ids = [var.project_id]
    permission_set_names = [
      "ObjectStorageObjectsWrite",
      "ObjectStorageObjectsDelete",
      "ObjectStorageObjectsRead",
      "ObjectStorageBucketsRead",
      "ObjectStorageReadOnly"
    ]
  }
}

resource "scaleway_iam_application" "truenas_mail" {
  name            = "Mailing Apps"
  description     = "Application for TrueNAS apps to send e-mail."
  organization_id = var.organization_id
}

resource "scaleway_iam_policy" "truenas_send_mails" {
  name            = "TrueNAS Mails Policy"
  description     = "Gives TrueNAS apps permission to send e-mails."
  application_id  = scaleway_iam_application.truenas_mail.id
  organization_id = var.organization_id
  rule {
    project_ids = [var.project_id]
    permission_set_names = [
      "TransactionalEmailEmailSmtpCreate"
    ]
  }
}

resource "scaleway_object_bucket" "truenas_backup" {
  name       = "lal-truenas-backup"
  project_id = var.project_id

  lifecycle_rule {
    id      = "to-glacier-weekly"
    enabled = true

    transition {
      days          = 7
      storage_class = "GLACIER"
    }
  }
}

resource "scaleway_iam_ssh_key" "lal_0" {
  name       = "lal_0"
  public_key = var.public_ssh_key
}
