#!/bin/bash
# Script para decodificar masivamente engramas de ARCA

for archivo in *.txt; do
    # 1. Extraer y mostrar la cabecera (Metadatos y Tiempo) 
    # Se usa el primer campo antes del separador '|'
    CABECERA=$(cut -d'|' -f1 "$archivo")
    #echo -e "\e[1;34mArchivo: $archivo\e[0m \e[1;32m$CABECERA\e[0m"

    # 2. Extraer el contenido Base64 tras el separador '|' 
    # Se decodifica usando 'base64 -d' como en el motor de búsqueda 
    CONTENIDO_B64=$(cut -d'|' -f3 "$archivo" | tr -d ' ')
#    echo "$CONTENIDO_B64"
#    echo -n "Contenido: "
    echo "$CONTENIDO_B64" | base64 -d  #2>/dev/null || echo "Error de decodificación"
    echo ""
#    echo -e "\n------------------------------------------------------------\n"
done
