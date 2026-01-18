#!/bin/bash
# Proyecto Channel-9 / Biblioteca del Arca
# Objetivo: Descargar instaladores STANDALONE de Rust para instalación 100% offline.

set -e

# --- Configuración de Rutas ---
RUST_OFFLINE_DIR="$HOME/public_html/rust"
VERSION="1.85.0" # Versión requerida por Memvid
ARCH="x86_64-unknown-linux-gnu"

echo "--- Iniciando descarga de binarios pesados de Rust v$VERSION ---"

# 1. Crear carpeta de destino
mkdir -p "$RUST_OFFLINE_DIR"
cd "$RUST_OFFLINE_DIR"

# 2. Descargar el instalador Standalone principal (Compilador + Cargo)
# Este es el "corazón" de Rust.
echo "Descargando Rust Standalone ($ARCH)..."
wget -c "https://static.rust-lang.org/dist/rust-${VERSION}-${ARCH}.tar.gz"

# 3. Descargar el Código Fuente de la Librería Estándar
# Memvid y muchas dependencias de Rust necesitan recompilar partes del core.
echo "Descargando Rust Source (necesario para compilación de crates)..."
wget -c "https://static.rust-lang.org/dist/rust-src-${VERSION}.tar.gz"

# 4. Descargar las firmas (para verificar integridad en el futuro)
echo "Descargando archivos de verificación (.asc)..."
wget -c "https://static.rust-lang.org/dist/rust-${VERSION}-${ARCH}.tar.gz.asc"
wget -c "https://static.rust-lang.org/dist/rust-src-${VERSION}.tar.gz.asc"

# 5. Crear el script de instalación local rápido
cat <<EOF > "$RUST_OFFLINE_DIR/install_offline.sh"
#!/bin/bash
# Script para instalar Rust desde los archivos locales en esta carpeta.
echo "Instalando Rust desde archivos locales..."
tar -xzf rust-${VERSION}-${ARCH}.tar.gz
cd rust-${VERSION}-${ARCH}
sudo ./install.sh --prefix=/usr/local
cd ..
echo "Instalando Código Fuente de Rust..."
tar -xzf rust-src-${VERSION}.tar.gz
cd rust-src-${VERSION}
sudo ./install.sh --prefix=/usr/local
cd ..
echo "Limpiando carpetas temporales..."
rm -rf rust-${VERSION}-${ARCH} rust-src-${VERSION}
echo "Rust instalado con éxito en /usr/local"
rustc --version
EOF

chmod +x "$RUST_OFFLINE_DIR/install_offline.sh"


# Descargar dependencias de compilación para llevar al búnker
echo "Descargando dependencias de OpenSSL para modo offline..."
mkdir -p "$RUST_OFFLINE_DIR/deps"
cd "$RUST_OFFLINE_DIR/deps"
apt-get download libssl-dev libssl3 pkg-config zlib1g-dev libxext6 libxrender1 libxtst6 libfontconfig1

# Actualizar el instalador offline para que las instale primero
cat <<EOF >> "$RUST_OFFLINE_DIR/install_offline.sh"
echo "Instalando dependencias de sistema locales..."
sudo dpkg -i deps/*.deb
EOF


echo "-------------------------------------------------------"
echo "TODO LISTO en: $RUST_OFFLINE_DIR"
echo "Archivos descargados:"
ls -lh "$RUST_OFFLINE_DIR"
echo "-------------------------------------------------------"
echo "Para instalar en otra máquina sin internet, copia esta"
echo "carpeta y ejecuta: ./install_offline.sh"
