#!/bin/bash
# 1_install_ollama.sh (v1.2 - Incluye Fuentes)
set -e

OUT_DIR="$HOME/public_html/ollama"
TEMP_DIR="$HOME/temp_ollama_build"
mkdir -p "$OUT_DIR" "$TEMP_DIR/DEBIAN" "$TEMP_DIR/usr"

# Necesitamos zstd para descomprimir el binario moderno de Ollama
sudo apt-get update && sudo apt-get install -y zstd wget tar

echo "--- 📦 Descargando Binario y Fuentes de Ollama v0.14.2 ---"
URL_BIN="https://github.com/ollama/ollama/releases/download/v0.14.2/ollama-linux-amd64.tar.zst"
URL_SRC="https://github.com/ollama/ollama/archive/refs/tags/v0.14.2.tar.gz"

wget -L "$URL_BIN" -O "$TEMP_DIR/ollama_bin.tar.zst"
wget -L "$URL_SRC" -O "$OUT_DIR/ollama_v0.14.2_sources.tar.gz"

echo "--- 🛠️ Preparando Paquete .deb ---"
tar --zstd -xf "$TEMP_DIR/ollama_bin.tar.zst" -C "$TEMP_DIR/usr/"
chmod +x "$TEMP_DIR/usr/bin/ollama"

cat <<EOF > "$TEMP_DIR/DEBIAN/control"
Package: ollama-arca
Version: 0.14.2
Architecture: amd64
Maintainer: ArcaProject
Description: Inferencia Ollama (Binarios + Librerías). Fuentes adjuntas en carpeta.
EOF

dpkg-deb --build "$TEMP_DIR" "$OUT_DIR/ollama-arca_amd64.deb"
rm -rf "$TEMP_DIR"

echo "--- 🚀 Instalando Ollama en el sistema de desarrollo ---"
sudo dpkg -i "$OUT_DIR/ollama-arca_amd64.deb"

echo "✅ Listo: .deb y código fuente en $OUT_DIR"
