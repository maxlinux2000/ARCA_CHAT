#!/bin/bash
# Script 1: Descarga y Preparación del Motor MemVid (Yobix-ai Extractous)
set -e

BASE_DIR="$HOME/public_html/MemVid"
SRC_DIR="$BASE_DIR/sources"
EXTRACTOUS_DIR="$SRC_DIR/extractous"

# 1. Limpieza y preparación
rm -rf "$EXTRACTOUS_DIR"
mkdir -p "$SRC_DIR"
cd "$SRC_DIR"

echo "--- Descargando código fuente desde yobix-ai ---"
wget -L -O extractous.tar.gz https://github.com/yobix-ai/extractous/archive/refs/heads/main.tar.gz

# 2. Extracción y normalización
echo "Extrayendo archivos..."
tar -xzf extractous.tar.gz
# GitHub siempre mete todo en una carpeta llamada 'nombre-del-repo-rama'
mv extractous-main extractous
rm extractous.tar.gz

# 3. Preparación de la maleta offline (Vendoring)
# IMPORTANTE: Entramos en la subcarpeta donde reside el motor real
cd "$EXTRACTOUS_DIR/extractous-core"

echo "Preparando dependencias de Rust en $(pwd)..."
mkdir -p .cargo

# Intentamos cargar Cargo si ya instalaste Rust previamente
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Ahora sí encontrará el Cargo.toml en esta subcarpeta
cargo vendor > .cargo/config.toml

echo "--- SCRIPT 1 COMPLETADO ---"
echo "Las fuentes y dependencias están listas en: $EXTRACTOUS_DIR/extractous-core"
