terraform {
  required_version = ">= 1.3"
  required_providers {
    supabase = {
      source  = "supabase/supabase"
      version = "~> 0.7"
    }
    fly = {
      source  = "fly-apps/fly"
      version = "~> 0.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}
