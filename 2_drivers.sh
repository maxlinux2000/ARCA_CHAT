#!/bin/bash
# Instalador de Drivers para Debian 12
set -e

echo "--- Detectando Hardware ---"
GPU=$(lspci | grep -iE 'vga|3d|display')

sudo apt update
if echo "$GPU" | grep -iq "intel"; then
    echo "🔵 Intel detectada. Instalando Mesa Vulkan..."
    sudo apt install -y mesa-vulkan-drivers libvulkan1 vulkan-tools intel-media-va-driver-non-free
elif echo "$GPU" | grep -iq "nvidia"; then
    echo "🚀 NVIDIA detectada. Instalando CUDA..."
    sudo apt install -y nvidia-driver nvidia-vulkan-common nvidia-cuda-toolkit
fi

# Librerías de aceleración de CPU para apoyo
sudo apt install -y libopenblas0 libgomp1
