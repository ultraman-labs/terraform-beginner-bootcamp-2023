terraform {
  required_providers {
    terratowns ={
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  #backend "remote" {
  #  hostname = "app.terraform.io"
  #  organization = "Ultra-Man"
  
  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}

#cloud {
#    organization = "Ultra-Man"
#    workspaces {
#      name = "terra-house-1"
#    }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  bucket_name = var.bucket_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
}

resource "terratowns_home" "home" {
  name = "Comics"
  description = <<DESCRIPTION
EPISODE 1.0.0: Ultraman finds himself protecting Terra-Towns from a great foe.
Knowing he needs help...yet feeling alone, he may not be able
to beat this monster who is bent on destroying anything in its path.
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  #domain_name = "3fafa3.cloudfront.net"
  #domain_name = "module.terrahouse_aws.cloudfront.net"
  town = "missingo"
  content_version = 1
}