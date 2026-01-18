#!/bin/bash
# Proyecto Arca: Constructor Adaptativo v4.1 (Vulkan Hard-Bypass)
set -e

VERSION="1.4.1-arca"
TEMP_BUILD="$HOME/temp_llama_build"
SOURCE_DIR="$HOME/public_html/MemVid/sources/llama.cpp"
REPO_PATH="$HOME/public_html/MemVid/debian"
DEB_ROOT="$TEMP_BUILD/package_root"
OPT_BIN="/opt/arca/bin"

echo "--- Iniciando Reparación Vulkan v4.1 ---"

# 1. Limpieza total del código fuente para evitar parches corruptos previos
echo "Restaurando código original..."
git -C "$SOURCE_DIR" checkout ggml/src/ggml-vulkan/ggml-vulkan.cpp 2>/dev/null || true

# 2. PARCHE DE FUERZA BRUTA (Sustitución completa de la función)
# Usamos un bloque heredoc para reescribir la función conflictiva entera
python3 -c "
import sys
path = '$SOURCE_DIR/ggml/src/ggml-vulkan/ggml-vulkan.cpp'
with open(path, 'r') as f:
    lines = f.readlines()

new_content = []
skip = False
for line in lines:
    if 'void ggml_vk_instance_init()' in line:
        new_content.append('void ggml_vk_instance_init() {\n')
        new_content.append('    vk::ApplicationInfo app_info(\"ggml\", 1, \"ggml\", 1, VK_API_VERSION_1_2);\n')
        new_content.append('    std::vector<const char*> layers;\n')
        new_content.append('    std::vector<const char*> extensions;\n')
        new_content.append('    vk::InstanceCreateInfo instance_create_info(vk::InstanceCreateFlags{}, &app_info, layers, extensions);\n')
        new_content.append('    vk_instance.instance = vk::createInstance(instance_create_info);\n')
        new_content.append('}\n')
        new_content.append('void ggml_vk_instance_destroy() { vk_instance.instance.destroy(); }\n')
        skip = True
    
    # Saltamos todo lo que pertenecía a la función vieja hasta encontrar la siguiente
    if skip and 'void ' in line and 'ggml_vk_instance_init' not in line:
        skip = False
    
    if not skip:
        new_content.append(line)

with open(path, 'w') as f:
    f.writelines(new_content)
"

# 3. Compilación con flags de supresión
rm -rf "$TEMP_BUILD"
mkdir -p "${TEMP_BUILD}/compile" "${DEB_ROOT}${OPT_BIN}" "${DEB_ROOT}/DEBIAN"
cd "${TEMP_BUILD}/compile"

echo "Lanzando CMake..."
cmake "$SOURCE_DIR" \
    -DGGML_VULKAN=ON \
    -DGGML_OPENBLAS=ON \
    -DGGML_NATIVE=ON \
    -DLLAMA_CURL=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DGGML_VULKAN_VALIDATE=OFF # Bandera extra para desactivar capas de error

cmake --build . --config Release -j$(nproc)

# 4. Empaquetado
BIN_MAIN=$(find . -name "llama-cli" -type f -executable | head -n 1)
[ -z "$BIN_MAIN" ] && BIN_MAIN=$(find . -name "main" -type f -executable | head -n 1)
cp "$BIN_MAIN" "${DEB_ROOT}${OPT_BIN}/llama-chat"

cat <<EOF > "${DEB_ROOT}/DEBIAN/control"
Package: arca-llama-vulkan
Version: $VERSION
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Arca Project
Description: Motor Llama optimizado para GPU (Fix v4.1)
Depends: libopenblas0, libvulkan1
EOF

cd "$TEMP_BUILD"
dpkg-deb --build package_root "arca-llama-vulkan.deb"
mv "arca-llama-vulkan.deb" "$REPO_PATH/"

echo "--- SUCESO: Binario generado ---"

