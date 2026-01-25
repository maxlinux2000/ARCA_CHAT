# ARCA_CHAT: Tu Bibliotecario IA Offline 📚🤖

**ARCA_CHAT** es una solución de inteligencia artificial diseñada para actuar como un bibliotecario personal, privado y resiliente. A diferencia de los modelos de chat comerciales, reside completamente en tu hardware, permitiéndote **dialogar directamente con tus propios documentos, libros y archivos** sin que un solo bit de información salga de tu equipo.

El proyecto nace de la necesidad de rescatar, organizar y consultar el conocimiento digital personal en un entorno de soberanía tecnológica absoluta.

---

## 🌟 El Corazón del Proyecto: Diálogo con la Biblioteca

El propósito principal de ARCA_CHAT es establecer un puente interactivo con tu propia base de conocimiento (la Biblioteca del Arca):

* **Interacción con Libros (RAG):** Puedes preguntarle a ARCA sobre conceptos específicos tratados en volúmenes extensos y recibir respuestas basadas exclusivamente en esos textos.
* **Análisis de Documentación:** Ideal para revisar manuales técnicos, documentos históricos o colecciones personales de manera conversacional.
* **Soberanía y Privacidad:** El "bibliotecario" trabaja a puerta cerrada. Todo el procesamiento es local, garantizando que el acceso al conocimiento no dependa de servidores externos ni de políticas de terceros.

---

## ⚙️ ¿Cómo funciona?

ARCA_CHAT utiliza una arquitectura de **Generación Aumentada por Recuperación** (RAG), combinando la potencia de procesamiento de lenguaje natural con una gestión de memoria local eficiente.

El proceso se divide en tres etapas:

1.  **Ingesta y Fragmentación:** El sistema procesa tus archivos (PDF, Markdown, Texto plano, etc.) y los divide en fragmentos manejables.
2.  **Indexación (La Memoria del Arca):** Estos fragmentos se convierten en representaciones numéricas (*embeddings*) almacenadas en una base de datos vectorial local. Esto permite a la IA localizar información relevante en segundos.
3.  **Consulta y Respuesta:** Al realizar una pregunta, el sistema busca los fragmentos más pertinentes en tu biblioteca y se los entrega al modelo de lenguaje local (`llama.cpp`) para generar una respuesta fundamentada únicamente en tus documentos.

El Flujo Operativo de ARCA

    Ingesta Genérica (arca-ingest): Se procesan los documentos (PDF/Texto) y se codifican visualmente para generar un video MP4. Este video sirve como el "contenedor" de la información íntegra tal como está en el libro de origen.

    Destilación Atómica (arca-distiller): El sistema analiza el video frame a frame. Utiliza gemma2:2b (u otro modelo ligero) para interpretar los datos de cada QR/Frame y extraer átomos de conocimiento (síntesis corta y pura).

    Indexación Maestro (engram.mv2): Estos átomos se guardan en archivos .txt (codificados en Base64) y se empaquetan en un único índice vectorial maestro: engram.mv2.

    Consulta Inteligente (arca-chat): En lugar de navegar por toda la biblioteca de libros originales, el chat consulta exclusivamente la destilación. Esto garantiza respuestas técnicas, ultra-rápidas y libres de "paja" literaria.

    Adaptabilidad de Recursos: El sistema detecta la RAM física para ajustar la ventana de contexto (2048 o 4096 tokens) y el número de átomos (2 o 3) que la IA puede "recordar" simultáneamente.

Ejemplo:
## 🚀 Flujo de Trabajo: De PDF a Memoria Atómica

El sistema **ARCA** utiliza un proceso de destilación único para transformar documentos densos en engramas tácticos consultables en tiempo real.

### 1. Ingesta (Generación de Vídeo MP4)
Primero, convertimos el documento original en un contenedor visual de alta densidad (MP4) que facilita el procesamiento por frames.
```bash
arca-ingest /ruta/al/libro_estrategia.pdf
```

Salida: Se genera un archivo en ~/IA/vectors/libro_estrategia.mp4.

2. Destilación (Extracción de Engramas)

Ejecutamos el destilador atómico. El sistema analiza el video frame a frame, utiliza Gemma 2B para sintetizar cada concepto y genera una base de datos de "átomos de conocimiento" en formato .mv2.

```
arca-distiller ~/IA/vectors/libro_estrategia.mp4
```
# Inicia el núcleo de chat
```
arca-chat
```
# O usa el modo debug para ver los engramas recuperados
```
arca-chat --debug
```
🧠 Arquitectura del Sistema

Ingest	arca-ingest	Codifica PDFs en secuencias de video QR/Visual.
Distill	arca-distiller	Síntesis IA de frames y guardado en Base64.
Search	arca-atomic-search	Búsqueda vectorial ultra-rápida en engram.mv2.
Chat	arca-chat	Interfaz de operador con contexto dinámico según RAM.

Nota de eficiencia: ARCA no lee el libro completo en cada pregunta; consulta directamente los átomos destilados, lo que permite respuestas técnicas y precisas en segundos.

📦 Instalación en Debian y Derivados

La implementación del ecosistema ARCA está diseñada para ser modular y sencilla, ideal para entornos sin conexión permanente a internet. El proceso de despliegue se realiza ejecutando una secuencia lógica de scripts numerados que preparan desde las dependencias básicas hasta el entorno de ejecución de la IA.

Para instalar el sistema completo, simplemente ejecuta los scripts del 1 al 6 en orden secuencial desde tu terminal:

---

## 🛠️ Tecnologías Clave

Para asegurar el funcionamiento en hardware doméstico y sistemas aislados (Debian 12 / Raspberry Pi), ARCA_CHAT se apoya en:

* **ollama:** El motor principal para ejecutar modelos de lenguaje potentes con alta eficiencia.
* **Memvid:** Integración para la gestión inteligente del contexto y la memoria de largo plazo de los documentos.
* **Instalación Offline:** Uso de scripts para empaquetar dependencias y modelos, permitiendo el despliegue del sistema sin necesidad de conexión a internet.

---

> [!IMPORTANT]
> **Estado del proyecto:** ARCA_CHAT se encuentra actualmente "en altamar". El desarrollo está en fase activa de arquitectura y diseño de la base de datos vectorial. Los scripts de despliegue final se añadirán una vez consolidada la estructura del "Bibliotecario".
