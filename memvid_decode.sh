#!/bin/bash
# Proyecto Arca: Decodificador de Video QR v2.2
# Binarios: ZXingReader (Paquete zxing-cpp-tools)

# --- 1. VALIDACIÓN DE ENTORNO ---
if ! command -v ZXingReader &> /dev/null; then
    echo "ERROR: No se encuentra ZXingReader."
    echo "Instalación: sudo apt update && sudo apt install -y zxing-cpp-tools"
    exit 1
fi

VIDEO_IN="$1"
[ ! -f "$VIDEO_IN" ] && echo "Uso: ./memvid_decode.sh video.mp4" && exit 1

DEBUG_DIR="/tmp/arca_decode_zxing"
rm -rf "$DEBUG_DIR" && mkdir -p "$DEBUG_DIR"

echo "--- DECODIFICADOR ARCA (Motor ZXing-C++ PascalCase) ---"
echo "Analizando: $(basename "$VIDEO_IN")"
echo "--------------------------------------------------------"

# 2. EXTRACCIÓN DE FOTOGRAMAS (Calidad 1:1)
ffmpeg -i "$VIDEO_IN" -vf "fps=1/3,scale=1280:-1" "$DEBUG_DIR/f_%03d.png" -loglevel error

# 3. LECTURA CON ZXingReader
ULTIMO_TEXTO=""

for img in $(ls "$DEBUG_DIR"/f_*.png | sort); do
    # ZXingReader por defecto escupe mucha info (formato, posición, etc.)
    # Usamos grep/sed para limpiar y quedarnos solo con el contenido del mensaje
    RESULTADO=$(ZXingReader "$img" 2>/dev/null)
    
    if [ -n "$RESULTADO" ]; then
        # El binario suele devolver: "Text: [el contenido]"
        # Filtramos para obtener solo lo que hay después de "Text: "
        TEXTO=$(echo "$RESULTADO" | grep "Text:" | sed 's/^Text: //')
        
        # Si por alguna versión de la herramienta el prefijo cambia, 
        # nos aseguramos de no perder el texto:
        [ -z "$TEXTO" ] && TEXTO=$(echo "$RESULTADO" | head -n 1)

        if [ "$TEXTO" != "$ULTIMO_TEXTO" ]; then
            PUNTO=$(basename "$img" .png | sed 's/f_//')
            echo -e "\e[34m[ PUNTO $PUNTO ]\e[0m"
            # Imprimimos tal cual, ZXingReader maneja UTF-8 nativamente
            echo -e "$TEXTO"
            echo "--------------------------------------------------------"
            ULTIMO_TEXTO="$TEXTO"
        fi
    fi
done

rm -rf "$DEBUG_DIR"
echo "Proceso finalizado."
