#!/bin/bash
# setup-distiller-model.sh
source "$HOME/IA/arca.conf"

MODEL_NAME="arca-distiller-brain"

echo "--- 🧠 Creando Modelfile para Destilación Atómica ---"

cat << EOF > Modelfile.distiller
FROM gemma2:2b
PARAMETER temperature 0
PARAMETER num_ctx 4096
SYSTEM """
Eres un extractor de datos técnicos para un sistema de memoria RAG.
Tu única función es leer fragmentos de texto y devolver una lista de HECHOS ATÓMICOS.
REGLAS:
1. No saludes ni des introducciones.
2. Cada hecho debe ser una sola frase breve y directa.
3. No inventes información fuera del texto proporcionado.
4. Mantén un tono técnico y objetivo.
"""
EOF

ollama create $MODEL_NAME -f Modelfile.distiller
rm Modelfile.distiller

echo "✅ Modelo '$MODEL_NAME' creado con éxito."
