output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value = module.home_ultra_hosting.bucket_name
}

output "s3_website_endpoint" {
  description = "S3 static website hosting endpoint"
  value = module.home_ultra_hosting.website_endpoint
}

output "cloudfront_url" {
  description = "The Cloudfront Distribution Domain Name"
  value = module.home_ultra_hosting.domain_name
  
}
