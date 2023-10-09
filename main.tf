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
  endpoint = "http://localhost:4567/api"
  user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}

# module "terrahouse_aws" {
  # source = "./modules/terrahouse_aws"
  # user_uuid = var.user_uuid
  # bucket_name = var.bucket_name
  # index_html_filepath = var.index_html_filepath
  # error_html_filepath = var.error_html_filepath
  # content_version = var.content_version
# }

resource "terratowns_home" "home" {
  name = "Ultraman Comics"
  description = <<DESCRIPTION
EPISODE 1.0.0: Ultraman finds himself protecting Terra-Towns from a great foe.
Knowing he needs help...yet feeling alone, he may not be able
to beat this monster who is bent on destroying anything in its path.
DESCRIPTION
  #domain_name = module.terrahouse_aws.cloudfront_url
  domain_name = "3fdq3gz.cloudfront.net"
  town = "gamers-grotto"
  content_version = 1
}