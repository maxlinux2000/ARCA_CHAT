#!/bin/bash
# Instalador Final y Creación del Wrapper
set -e

echo "--- Instalando Paquetes locales ---"
sudo dpkg -i "$HOME/public_html/memvid/arca-memvid_amd64.deb"
sudo apt install -y -f # Corregir dependencias faltantes
sudo apt install -y jq poppler-utils antiword # Herramientas de extracción de texto

# Configuración de carpetas
mkdir -p "$HOME/IA/vectors" "$HOME/IA/docs" "$HOME/.local/bin"

cp ./arca $HOME/.local/bin/
cp ./arca-ingest $HOME/.local/bin/
cp ./arca-search $HOME/.local/bin/
cp ./arca-ask $HOME/.local/bin/


chmod +x "$HOME/.local/bin/arc*"
echo "✅ Instalación completada. Prueba con: arca"
