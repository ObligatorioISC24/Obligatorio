#!/bin/bash

# Variables de configuración
DB_HOST=$DB_HOST
DB_USER="root"
DB_PASS=$DB_PASS
DB_NAME="idukan"
TABLE_NAME="tbl_category"

# Comando para ejecutar la consulta SQL
query="SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '${DB_NAME}' AND table_name = '${TABLE_NAME}';"

# Ejecutar la consulta SQL y almacenar el resultado en una variable
result=$(mysql -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASS}" -e "${query}" -s -N)

# Verificar el resultado de la consulta
if [ "${result}" -eq 0 ]; then
    # Comando para cargar el dump en la base de datos
    mysql -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASS}" "${DB_NAME}" < /home/ec2-user/dump.sql
	echo "Carga del dump exitosa" > /var/log/dump.log
else
    echo "La tabla ${TABLE_NAME} ya existe en la base de datos ${DB_NAME}. No es necesario cargar el dump." > /var/log/dump.log
fi