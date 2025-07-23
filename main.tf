resource "scaleway_iam_application" "truenas" {
  name        = "TrueNAS"
  description = "Application for TrueNAS to access Scaleway resources."
  organization_id = var.organization_id
}

resource scaleway_iam_policy "truenas_manage_s3" {
  name           = "TrueNAS S3 Management Policy"
  description    = "Gives TrueNAS permissions to upload/download objects in the S3 bucket."
  application_id = scaleway_iam_application.truenas.id
  organization_id = var.organization_id
  rule {
    project_ids          = [var.project_id]
    permission_set_names = [
      "ObjectStorageObjectsWrite",
      "ObjectStorageObjectsDelete",
      "ObjectStorageObjectsRead",
      "ObjectStorageBucketsRead",
      "ObjectStorageReadOnly"
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

locals {
  headscale_zone = "nl-ams-1"
}

resource "scaleway_instance_ip" "headscale" {
  type = "routed_ipv6"
  zone = local.headscale_zone
}

data "scaleway_marketplace_image" "fedora" {
  label = "fedora_41"
  zone = local.headscale_zone
}

resource "scaleway_instance_security_group" "headscale" {
  zone = local.headscale_zone
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"
  external_rules = true
}

resource "scaleway_instance_security_group_rules" "headscale" {
  security_group_id = scaleway_instance_security_group.headscale.id
  inbound_rule {
    action = "accept"
    port   = "22"
    ip_range  = "::/0" 
    protocol = "TCP"
  }

  inbound_rule {
    action = "accept"
    port   = "443"
    ip_range  = "::/0"
    protocol = "TCP"
  }
}

resource "scaleway_instance_server" "headscale" {
  type  = "STARDUST1-S"
  zone = local.headscale_zone
  image = regex(".+/(.+)",data.scaleway_marketplace_image.fedora.id)[0]
  root_volume {
    size_in_gb = 10
    volume_type = "l_ssd"
    delete_on_termination = true

  }

  tags = ["headscale"]

  ip_id = scaleway_instance_ip.headscale.id
  security_group_id = scaleway_instance_security_group.headscale.id
}
