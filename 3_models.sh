#!/bin/bash
# Descarga de modelos basada en RAM
set -e

IA_DIR="$HOME/IA/models"
mkdir -p "$IA_DIR"
export OLLAMA_MODELS="$IA_DIR"

TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
echo "RAM Total detectada: ${TOTAL_RAM}GB"

# 1. El modelo de RAG (siempre pequeño y rápido)
echo "--- Descargando modelo de Embeddings/RAG ---"
ollama pull nomic-embed-text

# 2. El modelo de Lenguaje (Dinámico)
if [ "$TOTAL_RAM" -gt 24 ]; then
    echo "Cerebro Grande: Llama 3.1 8B (Q4_K_M)"
    ollama pull llama3.1:8b
elif [ "$TOTAL_RAM" -gt 10 ]; then
    echo "Cerebro Medio: Llama 3.2 3B"
    ollama pull llama3.2
else
    echo "Cerebro Pequeño: Gemma 2b"
    ollama pull gemma:2b
fi

pkill ollama
