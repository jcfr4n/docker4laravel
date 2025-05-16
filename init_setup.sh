#!/bin/bash

# Script para inicializar el entorno de desarrollo con Docker por primera vez, si ya se ha inicializado con anterioridad usar init.sh
echo "clear"
echo "Iniciando el script de configuración inicial..."
echo ""
echo "Este script generará un archivo .env.docker en la carpeta docker y levantará los contenedores de Docker necesarios para el entorno de desarrollo."
echo "Asegúrate de tener Docker y Docker Compose instalados y en ejecución."
echo ""
echo "Si ya has ejecutado este script antes, puedes usar el script init.sh para levantar los contenedores sin volver a generar el archivo .env.docker."
echo ""
echo "Presiona Enter para continuar o Ctrl+C para cancelar."
read -r
echo ""
echo "Iniciando el script de configuración inicial..."
echo ""

# Ruta al archivo .env.docker
ENV_FILE="./docker/.env.docker"

# Detectar UID y GID del usuario actual
USER_ID=$(id -u)
GROUP_ID=$(id -g)

# Nombre y password de usuario de la base de datos
DB_USERNAME="dbuser"
DB_PASSWORD="dbuser"
DB_ROOT_PASSWORD="root"

# Detectar nombre del directorio actual
CURRENT_DIR=$(basename "$PWD")

# Crear o actualizar .env.docker
echo "Generando ${ENV_FILE} con UID=${USER_ID} y GID=${GROUP_ID}"

cat > "$ENV_FILE" <<EOF
APP_NAME="${CURRENT_DIR}"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL="http://${CURRENT_DIR}.localhost:8000"
APP_PORT=8000

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=${CURRENT_DIR}
DB_USERNAME=${DB_USERNAME}
DB_PASSWORD=${DB_PASSWORD}
DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD}
DB_CHARSET=utf8mb4
DB_COLLATION=utf8mb4_unicode_ci

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_CLIENT_PORT=1025
MAIL_SERVER_PORT=8025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="no-reply@.com"
MAIL_FROM_NAME="Libro"

USER_ID=${USER_ID}
GROUP_ID=${GROUP_ID}

XDEBUG_MODE=debug
XDEBUG_CONFIG="client_host=host.docker.internal"
EOF

# Copiar el archivo .env.docker a .env, sobrescribiendo si existe
if [ -f ".env" ]; then
    echo "Sobrescribiendo .env existente con ${ENV_FILE}"
    cp "$ENV_FILE" .env
else
    echo "Creando .env a partir de ${ENV_FILE}"
    cp "$ENV_FILE" .env
fi

# Construir y levantar los contenedores
echo "Levantando contenedores con Docker Compose..."
docker-compose --env-file "$ENV_FILE" up -d --build

echo ""
echo "Contenedores levantados. Laravel estará disponible en http://localhost:8000"
echo ""
echo "Para acceder a la base de datos MySQL, usa los siguientes datos:"
echo "  - Host: ${CURRENT_DIR}.localhost"
echo "  - Puerto: 3306"
echo "  - Usuario: ${DB_USERNAME}"
echo "  - Contraseña: ${DB_PASSWORD}"
echo "  - Base de datos: ${CURRENT_DIR}"
echo ""
echo "Para acceder a phpMyAdmin, usa los siguientes datos:"
echo "  - URL: http://${CURRENT_DIR}localhost:8080"
echo "  - Usuario: ${DB_USERNAME}"
echo "  - Contraseña: ${DB_PASSWORD}"
echo ""
echo "Para acceder al servicio de mailpit, usa los siguientes datos:"
echo "  - URL: http://${CURRENT_DIR}.localhost:8025"
echo ""
echo "Para detener los contenedores, usa: docker-compose down"
echo "Para eliminar los contenedores y volúmenes, usa: docker-compose down -v"
echo "Para eliminar la red, usa: docker network rm ${CURRENT_DIR}-docker-network"
echo "Para eliminar la imagen, usa: docker rmi ${CURRENT_DIR}-docker"
echo "Para eliminar el contenedor, usa: docker rm -f ${CURRENT_DIR}-docker"