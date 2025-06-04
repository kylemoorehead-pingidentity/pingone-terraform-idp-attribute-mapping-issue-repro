terraform {
  required_providers {
    pingone = {
      source  = "pingidentity/pingone"
    }
  }
}

provider "pingone" {
  client_id         = var.worker_id
  client_secret     = var.worker_secret
  environment_id    = var.pingone_environment_id
  region_code       = var.region_code
}
