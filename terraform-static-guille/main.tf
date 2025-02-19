# main.tf
# Proyecto: terraform-static-guille

/*
Descripción: Plantilla de Terraform para desplegar un website estático en un Bucket S3
en la region eu-west-1 (Irlanda), done los nombres de los recursos son de guille
*/

/*
Además, se cargan dos archivos HTML (index.html y error.html) al bucket

Pasos para desplegar:
1. Ejecuta 'terraform init' para inicializar el proyecto
2. Ejecuta 'terraform plan' para revisar el plan de ejecución
3. Ejecuta 'terraform validate' para verificar la estructura
4. Ejecuta 'terraform fmt' para corregir errores de sintaxis
5. Ejecuta 'terraform apply' para despliegue
*/

# Cargamos el archivo index.html en el bucket.
# Utilizamos la propiedad "content" para definir el contenido inline.

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_site_bucket.id
  key          = "index.html"
  content      = "<html><head><title>Keepiando AWS con Guille</title></head><body><h1>Bienvenido keepcoder a la pagina de pruebas de Guillermo Rodrigues</h1></body></html>"
  content_type = "text/html"
}

# Cargamos el archivo error.html en el bucket, que se mostrará en caso de error.

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.static_site_bucket.id
  key          = "error.html"
  content      = "<html><head><title>Error</title></head><body><h1>Disculpa keepcoder, ha ocurrido un error en la pagina de Guillermo</h1></body></html>"
  content_type = "text/html"
}