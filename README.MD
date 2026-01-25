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

Conceptos Avanzados: Atomic-Search y Destilación con Doble IA

La arquitectura de la Biblioteca del Arca implementa el concepto de Atomic-Search, un método de recuperación que descompone las consultas complejas en unidades mínimas de significado para garantizar que la IA localice el dato exacto, incluso en documentos de miles de páginas donde la semántica puede ser ambigua. Este proceso se potencia mediante una destilación con doble modelo de IA: un primer modelo "Maestro" de gran escala (ej. Llama 70b) se utiliza en una fase previa fuera de línea para etiquetar y destilar el conocimiento crítico de tu biblioteca hacia un modelo "Estudiante" más compacto y eficiente (ej. Mistral o Qwen 8b). Este flujo de doble modelo permite que el "Estudiante", que es el que reside físicamente en tu hardware local, mantenga una precisión técnica excepcional y una lógica de razonamiento superior sin necesidad de los recursos masivos del modelo original, eliminando alucinaciones y optimizando la velocidad de respuesta en el escenario offline del Arca.


---

## 🛠️ Tecnologías Clave

Para asegurar el funcionamiento en hardware doméstico y sistemas aislados (Debian 12 / Raspberry Pi), ARCA_CHAT se apoya en:

* **ollama:** El motor principal para ejecutar modelos de lenguaje potentes con alta eficiencia.
* **Memvid:** Integración para la gestión inteligente del contexto y la memoria de largo plazo de los documentos.
* **Instalación Offline:** Uso de scripts para empaquetar dependencias y modelos, permitiendo el despliegue del sistema sin necesidad de conexión a internet.

---

> [!IMPORTANT]
> **Estado del proyecto:** ARCA_CHAT se encuentra actualmente "en altamar". El desarrollo está en fase activa de arquitectura y diseño de la base de datos vectorial. Los scripts de despliegue final se añadirán una vez consolidada la estructura del "Bibliotecario".
