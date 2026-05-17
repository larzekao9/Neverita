---
name: feedback-no-coauthor
description: No agregar Co-Authored-By de Claude en los commits de este proyecto
metadata:
  type: feedback
---

No incluir la línea `Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>` en los mensajes de commit.

**Why:** El usuario no quiere que Claude aparezca como contribuidor en el historial de git del repositorio.

**How to apply:** Siempre omitir esa línea al hacer commits en este proyecto.
