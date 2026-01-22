#!/bin/bash
# 3_models.sh - Gestión de modelos y creación de especialistas
set -e

IA_DIR="$HOME/IA/models"
mkdir -p "$IA_DIR"
export OLLAMA_MODELS="$IA_DIR"

TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
echo "RAM Total detectada: ${TOTAL_RAM}GB"

# 1. El modelo de RAG (Embeddings)
echo "--- Descargando modelo de Embeddings ---"
ollama pull nomic-embed-text

# 2. Descarga de Base para Extracción (Siempre Gemma 2b por velocidad)
echo "--- Preparando base para Extractor ---"
ollama pull gemma2:2b

# 3. Creación del Modelfile Especialista
echo "--- Configurando arca-extractor ---"
cat <<EOF > especialista.mf
FROM gemma2:2b
PARAMETER temperature 0
PARAMETER repeat_penalty 1.4
PARAMETER num_predict 20
SYSTEM Extrae exclusivamente las 4 palabras clave técnicas de la frase proporcionada. Responde solo con las palabras separadas por espacios, sin listas ni explicaciones. Texto admitido 4 palabras.
EOF

ollama create arca-extractor -f especialista.mf
rm especialista.mf

# 4. El modelo de Lenguaje Principal (Dinámico)
if [ "$TOTAL_RAM" -gt 24 ]; then
    echo "Cerebro Grande: Llama 3.1 8B"
    ollama pull llama3.1:8b
elif [ "$TOTAL_RAM" -gt 10 ]; then
    echo "Cerebro Medio: Llama 3.2 3B"
    ollama pull llama3.2
else
    echo "Cerebro Pequeño: Gemma 2b"
    # Ya descargado en el paso 2
fi

echo "✅ Configuración de modelos completada."
