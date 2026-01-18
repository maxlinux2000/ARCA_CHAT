# ARCA_CHAT: Tu Bibliotecario IA Offline 📚🤖

**ARCA_CHAT** es una solución de inteligencia artificial diseñada para actuar como un bibliotecario personal y privado. A diferencia de los modelos de chat comerciales que dependen de la nube, ARCA_CHAT reside completamente en tu hardware, permitiéndote **dialogar directamente con tus propios documentos, libros y archivos** sin que un solo bit de información salga de tu equipo.

El proyecto nace de la necesidad de rescatar y organizar el conocimiento digital personal, permitiendo que miles de páginas de información acumulada se vuelvan accesibles y consultables mediante lenguaje natural.

---

## 🌟 El Corazón del Proyecto: Diálogo con Documentos

El propósito principal de ARCA_CHAT no es solo "preguntar cosas a la IA", sino establecer un puente interactivo con tu propia biblioteca. 

* **Interacción con Libros:** Puedes preguntarle a ARCA sobre conceptos específicos tratados en un libro de 500 páginas y recibir una respuesta basada exclusivamente en ese texto.
* **Análisis de Documentación:** Ideal para revisar manuales técnicos, documentos legales o colecciones de archivos personales de manera conversacional.
* **Soberanía Total:** Tus libros y documentos no son enviados a ningún servidor externo. El "bibliotecario" trabaja a puerta cerrada, garantizando privacidad absoluta.

---

## ⚙️ ¿Cómo funciona?

ARCA_CHAT utiliza una arquitectura de **Generación Aumentada por Recuperación** (RAG, por sus siglas en inglés), combinando la potencia de `llama.cpp` para el procesamiento del lenguaje y `Memvid` para la gestión del contexto.



El proceso se divide en tres etapas lógicas:

1.  **Ingesta y Fragmentación:** El sistema lee tus archivos (PDF, Markdown, Texto plano, etc.) y los divide en pequeños fragmentos manejables.
2.  **Indexación (La "Memoria"):** Estos fragmentos se convierten en *embeddings* (representaciones numéricas del significado) que se almacenan en una base de datos vectorial local. Esto permite a la IA localizar la información relevante en segundos.
3.  **Consulta y Respuesta:** Cuando haces una pregunta, el sistema busca en tu base de datos los fragmentos más parecidos a tu consulta. Luego, le entrega esos fragmentos a la IA local (`llama.cpp`) junto con tu pregunta para que pueda responderte basándose **únicamente** en la información encontrada en tus documentos.

---

## 🛠️ Tecnologías Clave

* **llama.cpp:** El motor que permite ejecutar modelos de lenguaje potentes (formato GGUF) de forma eficiente en hardware doméstico.
* **Memvid:** Integración para la gestión inteligente de la memoria y el contexto de los documentos.
* **Privacidad nativa:** Todo el procesamiento ocurre en local, sin necesidad de conexión a internet (offline-first).

---

> [!IMPORTANT]
> **Estado del proyecto:** ARCA_CHAT se encuentra actualmente "en altamar". El desarrollo está en fase activa de arquitectura y diseño. Los scripts de instalación y despliegue se añadirán una vez que la estructura base sea estable.
