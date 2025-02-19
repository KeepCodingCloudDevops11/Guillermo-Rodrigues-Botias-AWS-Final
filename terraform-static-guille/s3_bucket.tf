# s3_bucket.tf

# El nombre se compone de una parte fija (static_site_bucket) y un subfijo aleatorio.
# Etiquetas para identificar el recurso.

resource "aws_s3_bucket" "static_site_bucket" {
  bucket = "guille-static-website-${random_id.bucket_suffix.hex}"

  tags = {
    Name       = "terraform-static-guille"
    Enviroment = "Dev"
  }
}

# Recurso para desactivar el bloqueo de acceso público en el bucket.

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_site_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configuración independiente del website en el bucket.

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.static_site_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "static_site_bucket_policy" {
  bucket = aws_s3_bucket.static_site_bucket.id

  # Política que permite la lectura pública de todos los objetos en el bucket.

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.static_site_bucket.arn}/*"
      }
    ]
  })
}