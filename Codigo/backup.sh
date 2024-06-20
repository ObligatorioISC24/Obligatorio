#!/bin/bash

# Ruta de la carpeta de origen (donde están los archivos que quieres respaldar)
origen="/mnt/nfs/"

# Ruta de la carpeta base de destino (donde quieres respaldar los archivos)
base_destino="/mnt/backup"

# Crear una carpeta nueva con la fecha y hora actual como nombre
fecha=$(date +"%Y-%m-%d_%H-%M-%S")
destino="$base_destino/$fecha"

# Usamos rsync para realizar la copia de seguridad
rsync -av --delete "$origen/" "$destino/"

# Eliminar carpetas antiguas (mantener solo las últimas 7)
num_carpetas=$(ls -d $base_destino/*/ | wc -l)
if [ $num_carpetas -gt 7 ]; then
    ls -d $base_destino/*/ | head -n -$((num_carpetas-7)) | xargs rm -r
fi
