resource "aws_s3_bucket" "wordpress_media" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

