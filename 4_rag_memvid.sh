#!/bin/bash
# Proyecto: ARCA_CHAT - Script 4: Compilador Memvid (Lógica Unificada)
set -e

OUT_DIR="$HOME/public_html/memvid"
TEMP_BUILD="$HOME/temp_memvid_compile"
DEB_ROOT="$HOME/temp_memvid_deb"
INSTALL_PATH="/opt/arca/bin"
BIN_NAME="memvid"

echo "--- 1. Preparando entorno de compilación ---"
mkdir -p "$OUT_DIR" "$TEMP_BUILD"
mkdir -p "$DEB_ROOT/DEBIAN" "$DEB_ROOT$INSTALL_PATH"
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

echo "--- 2. Descargando fuentes de Memvid v2.0.134 ---"
URL_SRC="https://github.com/memvid/memvid/archive/refs/tags/v2.0.134.tar.gz"
wget -L "$URL_SRC" -O "$OUT_DIR/memvid_v2.0.134_sources.tar.gz"
tar -xzf "$OUT_DIR/memvid_v2.0.134_sources.tar.gz" -C "$TEMP_BUILD" --strip-components=1

echo "--- 3. Inyectando Lógica ARCA Core (Basado en Script 3) ---"
# Creamos el ejemplo arca_core.rs dentro de las fuentes descargadas
mkdir -p "$TEMP_BUILD/examples"
cat << 'RUST' > "$TEMP_BUILD/examples/arca_core.rs"
use std::env;
use std::path::PathBuf;
use memvid_core::{Memvid, PutOptions, SearchRequest};

fn main() -> std::result::Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();
    
    // MODO BÚSQUEDA: --search [query] --db [path.mv2]
    if args.iter().any(|arg| arg == "--search") {
        let query = args.get(2).cloned().unwrap_or_else(|| "información".to_string());
        let db_arg = args.iter().position(|r| r == "--db")
                     .and_then(|pos| args.get(pos + 1))
                     .map(PathBuf::from)
                     .unwrap_or_else(|| PathBuf::from("/opt/arca/vectors/default.mv2"));

        if !db_arg.exists() { return Ok(()); }
        
        let mut mem = Memvid::open(&db_arg)?;
        let request = SearchRequest { 
            query, top_k: 15, snippet_chars: 500,
            uri: None, scope: None, cursor: None, as_of_frame: None, as_of_ts: None, no_sketch: false,
        };

        let response = mem.search(request)?;
        for hit in response.hits {
            println!("{}", hit.text.replace('\n', " ").trim());
        }
        return Ok(());
    }

    // MODO INGESTA (Modificado para usar los flags de arca-ingest)
    // Uso: memvid --encode-video --input-dir [dir] --output-index [file.mv2] ...
    if args.iter().any(|arg| arg == "--output-index") {
        let idx_pos = args.iter().position(|r| r == "--output-index").unwrap();
        let mv2_path = PathBuf::from(&args[idx_pos + 1]);
        let input_dir = args.iter().position(|r| r == "--input-dir")
                        .and_then(|pos| args.get(pos + 1)).unwrap();
        
        let mut mem = Memvid::create(&mv2_path)?;
        
        // Simulación de ingesta por fragmentos (chunks)
        for entry in std::fs::read_dir(input_dir)? {
            let path = entry?.path();
            if path.is_file() {
                let bytes = std::fs::read(&path)?;
                let text = String::from_utf8_lossy(&bytes).into_owned();
                let options = PutOptions::builder().title(path.display().to_string()).build();
                mem.put_bytes_with_options(text.as_bytes(), options)?;
            }
        }
        mem.commit()?;
        return Ok(());
    }
    Ok(())
}
RUST

echo "--- 4. Compilando Binario Optimizado ---"
cd "$TEMP_BUILD"
cargo build --release --example arca_core

echo "--- 5. Empaquetando .deb ---"
cp target/release/examples/arca_core "$DEB_ROOT$INSTALL_PATH/$BIN_NAME"
chmod +x "$DEB_ROOT$INSTALL_PATH/$BIN_NAME"

cat <<EOF > "$DEB_ROOT/DEBIAN/control"
Package: arca-memvid
Version: 2.0.134-arca
Architecture: amd64
Maintainer: ArcaProject
Description: Motor vectorial Memvid con soporte para ingesta fragmentada y búsqueda por DB específica.
Depends: libssl3
EOF

dpkg-deb --build "$DEB_ROOT" "$OUT_DIR/arca-memvid_amd64.deb"

echo "-------------------------------------------------------"
echo "✅ COMPILACIÓN EXITOSA"
echo "El binario 'memvid' ahora soporta --db en búsqueda y --output-index en ingesta."
echo "-------------------------------------------------------"
