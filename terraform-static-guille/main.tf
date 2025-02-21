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
  content      = <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Guille Website</title>
  <style>
    /* Estilos generales para la página */
    body {
      margin: 0;
      padding: 0;
      font-family: Arial, sans-serif;
      background-color: olive;  /* Fondo verde oliva */
      color: yellow;            /* Letras en amarillo */
      text-align: center;
    }
    /* Contenedor para centrar el contenido */
    .container {
      max-width: 800px;
      margin: 50px auto;
      padding: 20px;
      border-radius: 8px;
      background-color: rgba(0, 0, 0, 0.2); /* Opcional: un fondo semi-transparente para el contenedor */
    }
    /* Estilos para la imagen de perfil (si deseas agregar una) */
    .profile-img {
      max-width: 200px;
      border-radius: 50%;
      margin-top: 20px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Bienvenido keepcoder a la página de pruebas de Guillermo Rodrigues</h1>
     <!-- Si deseas agregar una imagen de perfil, descomenta la siguiente línea y reemplaza la URL -->
    <!-- <img class="profile-img" src="https://via.placeholder.com/200" alt="Imagen de Perfil"> -->
  </div>
</body>
</html>
EOF
  content_type = "text/html"
}

# Cargamos el archivo error.html en el bucket, que se mostrará en caso de error.

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.static_site_bucket.id
  key          = "error.html"
  content      = <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Error - Guille Website</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: Arial, sans-serif;
      background-color: olive;  /* Fondo verde oliva */
      color: yellow;            /* Texto en amarillo */
      text-align: center;
    }
    .container {
      max-width: 800px;
      margin: 50px auto;
      padding: 20px;
      border-radius: 8px;
      background-color: rgba(0, 0, 0, 0.2); /* Fondo semi-transparente */
    }
    h1 {
      margin-bottom: 0.5rem;
    }
    p {
      line-height: 1.6;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Error - Página No Encontrada</h1>
    <p>Disculpa keepcoder, ha ocurrido un error en la página de Guillermo.</p>
  </div>
</body>
</html>
EOF
  content_type = "text/html"
}
