# Entorno de desarrollo para Laravel con Docker

Este repositorio proporciona un entorno de desarrollo completo y listo para usar para proyectos Laravel, utilizando Docker y Docker Compose. Permite levantar rápidamente todos los servicios necesarios (PHP, MySQL, Nginx, phpMyAdmin y Mailpit) sin necesidad de instalar dependencias manualmente en tu máquina local.

## ¿Qué incluye este entorno?

- **PHP 8.2 FPM** con extensiones necesarias para Laravel y Xdebug para depuración.
- **MySQL 8.0** como base de datos.
- **Nginx** como servidor web.
- **phpMyAdmin** para administración visual de la base de datos.
- **Mailpit** para pruebas de envío de correos electrónicos.
- **Node.js 18** instalado en el contenedor PHP para compilar assets.
- Configuración de **Xdebug** lista para usar con Visual Studio Code.
- Scripts de inicialización para facilitar la puesta en marcha.

## Estructura del repositorio

```
.
├── app/                  # Tu proyecto Laravel irá aquí
├── docker/
│   ├── nginx/
│   │   └── default.conf  # Configuración de Nginx
│   └── php/
│       ├── Dockerfile    # Imagen personalizada de PHP
│       └── xdebug.ini    # Configuración de Xdebug
├── docker-compose.yml    # Orquestación de servicios
├── init_setup.sh         # Script de configuración inicial
├── init.sh               # Script para levantar servicios ya configurados
├── README.md             # Este archivo
└── .vscode/              # Configuración recomendada para VS Code
```

## Primeros pasos

### 1. Requisitos previos

- [Docker](https://www.docker.com/get-started) y [Docker Compose](https://docs.docker.com/compose/) instalados.
- (Opcional) [Visual Studio Code](https://code.visualstudio.com/) con la extensión PHP Debug.

### 2. Configuración inicial

Ejecuta el siguiente script la **primera vez** para generar los archivos de entorno y construir los contenedores:

```sh
./init_setup.sh
```

Esto hará lo siguiente:

- Detectará el nombre del directorio y ese será el nombre del proyecto, base de datos y otras configuraciones
- Detectará tu usuario y grupo para evitar problemas de permisos.
- Creará el archivo `docker/.env.docker` con las variables necesarias.
- Copiará ese archivo como `.env` en la raíz.
- Construirá y levantará todos los servicios con Docker Compose.

### 3. Levantar el entorno (usos posteriores)

Para iniciar los servicios después de la configuración inicial, simplemente ejecuta:

```sh
./init.sh
```

Esto levantará los contenedores sin reconstruir imágenes ni regenerar archivos de entorno.

## Acceso a los servicios

- **Laravel:** http://<nombre_del_directorio>.localhost:8000
- **phpMyAdmin:** http://<nombre_del_directorio>.localhost:8080
- **Mailpit:** http://<nombre_del_directorio>.localhost:8025

### Credenciales de base de datos

- **Host:** <nombre_del_directorio>.localhost
- **Puerto:** 3306
- **Usuario:** dbuser
- **Contraseña:** dbuser
- **Base de datos:** <nombre_del_directorio>

> El nombre del directorio actual se utiliza como nombre de la base de datos y otros identificadores.

## Depuración con Xdebug

La configuración está lista para usar con Visual Studio Code. Solo necesitas instalar la extensión PHP Debug y usar la configuración incluida en `.vscode/launch.json`.

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Listen for Xdebug",
      "type": "php",
      "request": "launch",
      "port": 9003,
      "pathMappings": {
        "/var/www": "${workspaceFolder}/app"
      }
    }
  ]
}

```


## Comandos útiles

- Detener los contenedores:
  ```sh
  docker-compose down
  ```
- Eliminar contenedores y volúmenes:
  ```sh
  docker-compose down -v
  ```
- Reconstruir imágenes:
  ```sh
  docker-compose build --no-cache
  ```
- Correr la shell del contenedor con php, necesario para composer, node, npm, artisan
  ```sh
    docker exec -it <nombre_del_directorio>_app bash 
    ```

## Notas

- El código fuente de tu proyecto Laravel debe estar dentro de la carpeta `app/`.
- Puedes personalizar las variables de entorno en `docker/.env.docker` según tus necesidades.

---

## Licencia

Este proyecto está disponible bajo la licencia [CC0 1.0 Universal (Public Domain Dedication)](https://creativecommons.org/publicdomain/zero/1.0/deed.es).  
Puedes copiar, modificar, distribuir y utilizar el código para cualquier propósito, incluso comercial, sin pedir permiso.

---
¡Listo! Ahora puedes desarrollar aplicaciones Laravel de forma rápida y sencilla usando Docker.

## Nota importante:

Solo recuerda una cosa más, una vez clonado este repositorio deberías borrar el archivo oculto << .git >>, para poder luego sumarlo al repositorio correspondiente