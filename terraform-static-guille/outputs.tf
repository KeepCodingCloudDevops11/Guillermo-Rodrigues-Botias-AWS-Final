# outputs.tf

output "website_endpoint" {
  description = "Endpoint del sitio web estatico desplegado en s3"
  value       = "http://${aws_s3_bucket.static_site_bucket.bucket}.s3-website-eu-west-1.amazonaws.com"
}