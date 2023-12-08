# Bucket
resource "aws_s3_bucket" "static_website" {
  bucket = "ittalent-terraform-23"
  tags = {
    Name = "bucket static website"
  } 
}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  
}

resource "aws_s3_bucket_acl" "static_website" {
  depends_on = [ 
    aws_s3_bucket_ownership_controls.static_website, 
    aws_s3_bucket_public_access_block.static_website,
  ]
  
  bucket = aws_s3_bucket.static_website.id
  acl = "public-read"
}


locals {
  content_types = {
    css  = "text/css"
    html = "text/html"
    js   = "application/javascript"
    json = "application/json"
    txt  = "text/plain"
  }
}

resource "aws_s3_object" "static_website_files" {
  for_each = fileset("../site/", "*")
  bucket = aws_s3_bucket.static_website.id
  key = each.value
  source = "../site/${each.value}"
  content_type     = lookup(local.content_types, element(split(".", each.value), length(split(".", each.value)) - 1), "text/plain")
  content_encoding = "utf-8"

  acl = "public-read"
}

output "website_url" {
  value = "http://${aws_s3_bucket.static_website.bucket}.s3-website-sa-east-1.amazonaws.com"
  
}