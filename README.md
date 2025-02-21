# GuillermoRodrigues-AWS-final
Práctica final módulo AWS Guillermo Rodrigues Botias

## INDICE

* [*Primera parte*](#primera-parte) : Objetivo y Requisitos
* [*Segunda parte*](#segunda-parte) : Estrcutura y Comandos
* [*Tercera parte*](#tercera-parte) : Archivos
* [*Cuarta parte*](#cuarta-parte) : Despliegue de aplicación

 ## Primera Parte

 A continuación vamos a desplegar un website estático en un bucket s3 en Irlanda a tráves de Terraform, con el nombre guille-static-website.

Los requisistos previos son:

1. Instalaremos Terraform y comprobaremos su versión para verificarlo con ```terraform version```
2. Debemos tener una cuenta de AWS activa, una vez la tengamos instalada, configuramos AWS CLI con ```aws configure```, nos pedirá ingresar **Acces Key** y **Secret Key** y definiremos nuestra region, en este caso **eu-west-1**

 ## Segunda Parte

Tendremos que crear una carpeta donde iremos creando nuestros archivos necesarios para que nuestra aplicación funcione, dejandonos la siguiente [estructura](https://github.com/KeepCodingCloudDevops11/Guillermo-Rodrigues-Botias-AWS-Final/blob/main/terraform-static-guille/img/Estructura.png)

```bash
.gitignore – Archivo que indica qué se debe ignorar en Git.
.terraform/ – Carpeta generada por Terraform para almacenar plugins y módulos descargados.
.terraform.lock.hcl – Archivo de bloqueo de versiones de proveedores.
main.tf – Archivo con el contenido HTML inline entre otros recursos.
outputs.tf – Archivo con las salidas de Terraform.
provider.tf – Configuración del proveedor AWS.
random.tf – Generación del sufijo aleatorio para el bucket.
s3_bucket.tf – Configuración del bucket S3 y otros recursos.
terraform.tfstate – Archivo de estado de Terraform.
terraform.tfstate.backup – Copia de respaldo del archivo de estado.
```
* Para su comodidad puedes clonar el repositorio ya existente

```bash
git clone https://github.com/KeepCodingCloudDevops11/Guillermo-Rodrigues-Botias-AWS-Final.git
```

Una vez creado todo nos dirigimos a la carpeta raíz para trabajar desde allí.

* Estos son algunos **comandos** que necesitaremos para desplegar nuestra aplicación:

1. Ejecuta ```bash terraform init``` para inicializar el proyecto
2. Ejecuta ```bash terraform plan``` para revisar el plan de ejecución
3. Ejecuta ```bash terraform validate``` para verificar la estructura
4. Ejecuta ```bash terraform fmt``` para corregir errores de sintaxis
5. Ejecuta ```bash terraform apply``` para despliegue

 ## Tercera Parte

* A continuación veremos el contenido de cada uno de los archivos que debemos crear:
  
1. Archivo ```provider.tf ``` que nos definirá el provider de AWS y la región.

```bash
# provider.tf

provider "aws" {
  region = "eu-west-1"
}
```
2. Archivo ```random.tf```, lo utilizamos para generar un sufijo aleatorio y así asegurarnos de que el nombre del bucket sea único globalmente.

```bash
# random.tf

resource "random_id" "bucket_suffix" {
  byte_length = 4
}
```

3. Archivo ```s3_bucket.tf``` que nos servirá para servir como website estático y la política para permitir acceso público a sus objetos.

```bash
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
```

4. Archivo ```outputs.tf``` para definir un output que muestre el endpoint del nuestro sitio web, lo que nos puede servir para probar.

```bash
# outputs.tf

output "website_endpoint" {
  description = "Endpoint del sitio web estatico desplegado en s3"
  value       = "http://${aws_s3_bucket.static_site_bucket.bucket}.s3-website-eu-west-1.amazonaws.com"
}
```

5. Archivo ```main.tf```, podremosusarlo como archivo común e incluir comentarios sobre el proyecto.

```bash
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
```

## Cuarta Parte

1. Nos dirigimos a la carpeta raíz ```terraform-static-guille``` y ahí iniciamos en la terminal ```terraform init``` que nos descargará los plugins necesarios. [Iniciando Terraform](https://github.com/KeepCodingCloudDevops11/Guillermo-Rodrigues-Botias-AWS-Final/blob/main/terraform-static-guille/img/Iniciando%20terraform.png)
2. Podemos usar ```terraform plan``` para ver los [recursos](https://github.com/KeepCodingCloudDevops11/Guillermo-Rodrigues-Botias-AWS-Final/blob/main/terraform-static-guille/img/Plan%20de%20Terraform.png) que se van a crear.
3. Si usamos ```terraform fmt``` corregiremos errores de sintaxis y con ```terraform validate``` validamos que este todo correcto.
4. Desplegamos la aplicacion con ```terrafrom apply``` y damos ```yes``` para confirmarlo cuando nos lo solicite. [Desplegando](https://github.com/KeepCodingCloudDevops11/Guillermo-Rodrigues-Botias-AWS-Final/blob/main/terraform-static-guille/img/Despliegue%20de%20aplicacion.png)
5. Cuando se haya desplegado Terraform nos mostrará el output website, copiaremos la URL y accederemos a nuestro navegador (recomendable en incognito) y la pegamos para verificar que el [despliegue ha sido correcto](https://github.com/KeepCodingCloudDevops11/Guillermo-Rodrigues-Botias-AWS-Final/blob/main/terraform-static-guille/img/Aplicacion%20funcionando.png). Tambiién veremos en caso de [error](https://github.com/KeepCodingCloudDevops11/Guillermo-Rodrigues-Botias-AWS-Final/blob/main/terraform-static-guille/img/Error%20de%20carga.png) al cargar un mensaje personalizado.
6. También podemos acceder desde la [Cloud de AWS](https://github.com/KeepCodingCloudDevops11/Guillermo-Rodrigues-Botias-AWS-Final/blob/main/terraform-static-guille/img/AWS.png) en el apartado de S3 para verificar los recursos creados, y ver las URLs.
7. Con ```terrafrom destroy``` podemos eliminar todos los recursos creados.
