#!/bin/bash
# Proyecto Arca: Preparación de llama.cpp (Cerebro de la IA)
set -e

BASE_DIR="$HOME/public_html/MemVid"
SRC_DIR="$BASE_DIR/sources"
DEB_DIR="$BASE_DIR/debian"

echo "--- Descargando Llama.cpp (Master branch) ---"
mkdir -p "$SRC_DIR"

cd "$SRC_DIR"
rm -rf llama.cpp
# Descarga la última versión para asegurar compatibilidad total con Llama 3.1
wget -O llama_cpp.tar.gz https://github.com/ggerganov/llama.cpp/archive/refs/heads/master.tar.gz
tar -xzf llama_cpp.tar.gz
mv llama.cpp-master llama.cpp
rm llama_cpp.tar.gz

echo "--- Descargando dependencias de compilación ---"
mkdir -p "$DEB_DIR"
cd "$DEB_DIR"
sudo apt-get update
apt-get download libopenblas-dev libgomp1

echo "--- Llama.cpp listo para ser compilado ---"
