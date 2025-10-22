#!/bin/bash

# Script para limpiar archivos no rastreados del cache de git
# y actualizar el índice de git

echo "Eliminando archivos del cache de git..."
git rm -r --cached .

echo "Agregando archivos al índice de git..."
git add .

echo "Creando commit..."
git commit -m "fixed untracked files"

echo "¡Listo!"
