terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.57.0"
    }
  }
}

provider "scaleway" {
  # Configuration options
  region = "fr-par"
}