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

cloud {
   organization = "Ultra-Man"
   workspaces {
     name = "terra-house-1"
   }
 }
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "home_ultra_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.ultra.public_path
  #bucket_name = var.bucket_name
  content_version = var.ultra.content_version
}

resource "terratowns_home" "home" {
  name = "Comics"
  description = <<DESCRIPTION
EPISODE 1.0.0: Ultraman finds himself protecting Terra-Towns from a great foe.
Knowing he needs help...yet feeling alone, he may not be able
to beat this monster who is bent on destroying anything in its path.
DESCRIPTION
  domain_name = module.home_ultra_hosting.domain_name
  #domain_name = "3fafa3.cloudfront.net"
  #domain_name = "module.terrahouse_aws.cloudfront.net"
  town = "missingo"
  content_version = var.ultra.content_version
}

 module "home_tunz_hosting" {
   source = "./modules/terrahome_aws"
   user_uuid = var.teacherseat_user_uuid
   public_path = var.tunz.public_path
   content_version = var.tunz.content_version
 }
 resource "terratowns_home" "home_tunz" {
   name = "Tunz that evoke emotions of being alive"
   description = <<DESCRIPTION
 Musix traxs from post-punk, new wave, dance-rock, that
 relinquishes logic and evokes an emotional sea of being
 singularly alive.
 DESCRIPTION
   domain_name = module.home_tunz_hosting.domain_name
   #domain_name = "3fafa3.cloudfront.net"
   #domain_name = "module.terrahouse_aws.cloudfront.net"
   town = "missingo"
   content_version = var.tunz.content_version
 }