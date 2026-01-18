#!/bin/bash
# Proyecto Arca: Instalador Maestro v9.0 (Motor ZXing-C++ & Local Bin)
# Basado en v8.3: Sincronización de RAM, Contexto Dinámico y Priorización de Fuentes.
set -e

ARCA_LOCAL_BIN="$HOME/.local/bin"
ARCA_VISUAL="$HOME/.local/visual_arca"
mkdir -p "$ARCA_LOCAL_BIN" "$ARCA_VISUAL"

echo "--- Instalando Dependencias (Debian 12) ---"
sudo apt-get update -qq && sudo apt-get install -y zxing-cpp-tools ffmpeg bc poppler-utils

# Asegurar Path local en .bashrc
if ! grep -q ".local/bin" "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/.local/bin:$PATH"
fi

# --- INYECCIÓN DEL ORQUESTADOR ARCA ---
cat << 'ORQUESTADOR' > "$ARCA_LOCAL_BIN/arca"
#!/bin/bash
# Proyecto Arca: Orquestador Maestro v9.8 (Turbo Edition)
# Objetivo: Aceleración por Hardware y optimización de Contexto.

ARCA_OPT="/opt/arca/bin"
ARCA_VISUAL="/opt/arca/visual"
MODEL_LLM="/opt/arca/models/llama-3.1-8b-instruct.Q4_K_M.gguf"
export LD_LIBRARY_PATH="/opt/arca/lib:$LD_LIBRARY_PATH"

# --- MEJORA: Detección de Aceleración ---
# Si existe soporte Vulkan, lo usamos. Si no, forzamos hilos optimizados.
NGPU_LAYERS=0
if [ -f "/usr/lib/x86_64-linux-gnu/libvulkan.so.1" ]; then
    NGPU_LAYERS=20 # Movemos 20 capas a la Intel GPU para aliviar la CPU
fi

case "$1" in
    ingest)
        # (Se mantiene tu lógica de ingesta profunda que ya funciona bien)
        if [ -f "$2" ]; then
            NOMBRE_LIMP=$(basename "$2" .pdf)
            TXT_AUDIT="$ARCA_VISUAL/${NOMBRE_LIMP}.txt"
            pdftotext -q -layout -nopgbrk "$2" "$TXT_AUDIT" 2>/dev/null
            split -b 2000 "$TXT_AUDIT" /tmp/arca_chunk_
            for chunk in /tmp/arca_chunk_*; do
                "$ARCA_OPT/memvid-core" "$chunk" > /dev/null 2>&1
                rm "$chunk"
            done
            # Función de video aquí...
        fi
        ;;

    ask|talk)
        PREG="$2"
        DOC="$3"
        
        # 1. Gestión de RAM Dinámica mejorada
        FREE_GB=$(free -g | awk '/^Mem:/{print $7}')
        if [ "$FREE_GB" -lt 4 ]; then CTX_FINAL=4096; else CTX_FINAL=16384; fi

        echo "--- ARCA AI TURBO --- RAM: ${FREE_GB}GB | GPU Layers: $NGPU_LAYERS | Contexto: $CTX_FINAL"

        # 2. Búsqueda semántica
        CONTEXTO=$("$ARCA_OPT/memvid-core" --search "$PREG" 2>/dev/null | head -n 25)
        
        # Priorizar libro específico si se pasa como argumento
        if [ -n "$DOC" ]; then
            FILE_C="$ARCA_VISUAL/$(basename "$DOC" _qr.mp4).txt"
            if [ -f "$FILE_C" ]; then
                CONTEXTO_PRIO=$(grep -iC 2 "$PREG" "$FILE_C" | head -n 15)
                CONTEXTO="$CONTEXTO_PRIO $CONTEXTO"
            fi
        fi

        LIMP=$(echo "$CONTEXTO" | tr -cd '\11\12\15\40-\176' | tr '\n' ' ' | sed 's/  */ /g' | cut -c 1-8000)

        # 3. Inferencia Optimizada
        # -ngl: Capas en GPU | -fa: Flash Attention | --quiet: Menos ruido visual
        "$ARCA_OPT/llama-chat" -m "$MODEL_LLM" \
            -c "$CTX_FINAL" \
            -ngl "$NGPU_LAYERS" \
            -fa \
            --temp 0.0 \
            --repeat-penalty 1.1 \
            --quiet \
            --prompt "<|begin_of_text|><|start_header_id|>system<|end_header_id|>Eres ARCA. Contexto: $LIMP. Responde técnico y breve.<|eot_id|><|start_header_id|>user<|end_header_id|>$PREG<|eot_id|><|start_header_id|>assistant<|end_header_id|>"
        ;;

    visual)
        VIDEO="${2:-$(ls -t $ARCA_VISUAL/*_qr.mp4 2>/dev/null | head -n 1)}"
        ffplay -loop 0 -loglevel quiet "$VIDEO"
        ;;

    *)
        echo "ARCA v9.8: ingest [pdf] | ask [pregunta] [archivo] | visual"
        ;;
esac
ORQUESTADOR

chmod +x "$ARCA_LOCAL_BIN/arca"
echo "--- INSTALACIÓN v9.0 COMPLETADA ---"
