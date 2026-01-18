#!/bin/bash
# Proyecto Arca: Instalador de Aceleración por Hardware (Debian 12 - Mirror en Red)
set -e

echo "--- Iniciando Instalación de Drivers de Aceleración ---"

# Función para instalar paquetes de forma silenciosa y automática
install_pkg() {
    echo "  [ PROCESO ] Instalando: $@"
    sudo apt-get update -qq
    sudo apt-get install -y "$@"
}

# 1. Detección de GPU mediante lspci
GPU_INFO=$(lspci | grep -iE 'vga|3d|display')

if echo "$GPU_INFO" | grep -iq "NVIDIA"; then
    echo "🚀 DISPOSITIVO: NVIDIA Detectado."
    # Instalamos drivers y soporte CUDA desde tu mirror
    install_pkg nvidia-cuda-toolkit nvidia-driver nvidia-vulkan-common libnvcuvid1 libcuda1

elif echo "$GPU_INFO" | grep -iq "AMD"; then
    echo "🔴 DISPOSITIVO: AMD Detectado."
    # Instalamos soporte Vulkan para AMD (Mesa)
    install_pkg mesa-vulkan-drivers libvulkan1 vulkan-tools libva-mesa-driver

elif echo "$GPU_INFO" | grep -iq "Intel"; then
    echo "🔵 DISPOSITIVO: Intel Detectado (GPU Integrada)."
    # Instalamos soporte Vulkan para Intel (Ideal para el Latitude 5490)
    install_pkg mesa-vulkan-drivers libvulkan1 vulkan-tools intel-media-va-driver-non-free

else
    echo "💻 DISPOSITIVO: No se detectó GPU dedicada/compatible. Saltando a CPU."
fi

# 2. Aceleración de CPU (Obligatorio para Llama.cpp / Whisper.cpp)
echo "--- Asegurando Librerías de Aceleración de CPU ---"
install_pkg libopenblas0 libopenblas-dev libgomp1

# 3. Verificación de Vulkan (opcional pero recomendado)
if command -v vulkaninfo >/dev/null 2>&1; then
    echo "🔍 Verificando soporte Vulkan..."
    vulkaninfo | grep -i "deviceName" | head -n 1
fi

echo "-------------------------------------------------------"
echo "¡INSTALACIÓN FINALIZADA!"
echo "El sistema está listo para usar aceleración por hardware."
echo "-------------------------------------------------------"
