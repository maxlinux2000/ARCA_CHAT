#!/bin/bash
# Proyecto Arca: Descarga de Modelos (La Inteligencia)
set -e

MODEL_DIR="$HOME/public_html/MemVid/models"
mkdir -p "$MODEL_DIR"

echo "--- Descargando Modelos para el Búnker (Versión 3.1) ---"

# 1. El Cerebro (Llama-3.1 8B - Mejorado para contexto largo)
# Cambiamos a Llama-3.1 porque soporta 128k de contexto nativo.
if [ ! -f "$MODEL_DIR/llama-3.1-8b-instruct.Q4_K_M.gguf" ]; then
    echo "Descargando Llama-3.1-8B-Instruct (GGUF)..."
    wget -O "$MODEL_DIR/llama-3.1-8b-instruct.Q4_K_M.gguf" \
    https://huggingface.co/lmstudio-community/Meta-Llama-3.1-8B-Instruct-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf
fi

# 2. El Traductor (Embedding Model) - Sin cambios, sigue siendo excelente
if [ ! -f "$MODEL_DIR/nomic-embed-text-v1.5.f16.gguf" ]; then
    echo "Descargando Modelo de Embeddings (Nomic)..."
    wget -O "$MODEL_DIR/nomic-embed-text-v1.5.f16.gguf" \
    https://huggingface.co/nomic-ai/nomic-embed-text-v1.5-GGUF/resolve/main/nomic-embed-text-v1.5.f16.gguf
fi

echo "-------------------------------------------------------"
echo "¡MODELOS GUARDADOS! Ubicación: $MODEL_DIR"
echo "-------------------------------------------------------"
