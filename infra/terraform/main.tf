provider "supabase" {
  access_token = var.supabase_access_token
}

provider "fly" {
  access_token = var.fly_access_token
  org          = var.fly_org
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "supabase_project" "main" {
  organization_id   = var.supabase_organization_id
  name              = var.supabase_project_name
  database_password = var.supabase_db_password
  region            = var.supabase_region
  instance_size     = var.supabase_instance_size
}

data "supabase_apikeys" "main" {
  project_ref = supabase_project.main.id
}

resource "fly_app" "qdrant" {
  name = var.qdrant_app_name
}

resource "fly_volume" "qdrant" {
  app    = fly_app.qdrant.name
  name   = "data"
  region = var.qdrant_region
  size   = var.qdrant_volume_size
}

resource "fly_machine" "qdrant" {
  app      = fly_app.qdrant.name
  name     = "qdrant"
  region   = var.qdrant_region
  image    = var.qdrant_image
  cpus     = 2
  memorymb = 2048

  mounts = [{
    volume = fly_volume.qdrant.name
    path   = "/qdrant/storage"
  }]

  services = [{
    internal_port = 6333
    protocol      = "tcp"
    ports = [{
      port     = 80
      handlers = ["http"]
    }]
  }]
}

resource "fly_app" "typesense" {
  name = var.typesense_app_name
}

resource "fly_volume" "typesense" {
  app    = fly_app.typesense.name
  name   = "data"
  region = var.typesense_region
  size   = var.typesense_volume_size
}

resource "fly_machine" "typesense" {
  app      = fly_app.typesense.name
  name     = "typesense"
  region   = var.typesense_region
  image    = var.typesense_image
  cpus     = 2
  memorymb = 2048

  mounts = [{
    volume = fly_volume.typesense.name
    path   = "/data"
  }]

  services = [{
    internal_port = 8108
    protocol      = "tcp"
    ports = [{
      port     = 80
      handlers = ["http"]
    }]
  }]
}

resource "cloudflare_r2_bucket" "pdf_cache" {
  account_id = var.cloudflare_account_id
  name       = "orn-pdf-cache"
  location   = var.r2_location
}

resource "cloudflare_r2_custom_domain" "ipfs" {
  account_id  = var.cloudflare_account_id
  bucket_name = cloudflare_r2_bucket.pdf_cache.name
  domain      = var.ipfs_gateway_domain
  zone_id     = var.cloudflare_zone_id
  enabled     = true
}

resource "cloudflare_web3_hostname" "ipfs" {
  zone_id     = var.cloudflare_zone_id
  name        = var.ipfs_gateway_domain
  target      = "ipfs"
  description = "Public IPFS gateway"
  dnslink     = var.ipfs_dnslink
}
