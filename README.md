# Claude Code — Templates & Agents

Repositorio de configuración reutilizable para Claude Code. Incluye subagentes especializados, slash commands (skills), skills de terceros y el plugin MCP `code-review-graph` para análisis estructural de código.

Cloná esto en cualquier proyecto nuevo y tenés todo listo en 30 segundos.

---

## Contenido

```
.claude/
├── agents/          → subagentes especializados por rol
├── commands/        → slash commands invocables con /nombre
├── skills/          → skills instalados (referencias + scripts)
└── settings.json    → permisos base y MCP habilitados
.mcp.json            → configuración del plugin code-review-graph
setup.sh             → script de instalación automática
```

---

## Instalación en un proyecto nuevo

```bash
# 1. Clonar el repo dentro del proyecto
git clone https://github.com/larzekao9/claude.git .claude-template

# 2. Ejecutar el setup
cd .claude-template && chmod +x setup.sh && ./setup.sh ..

# 3. Eliminar el repo clonado (ya no lo necesitás)
cd .. && rm -rf .claude-template
```

O si preferís copiar manualmente:

```bash
git clone https://github.com/larzekao9/claude.git /tmp/claude-tpl
cp -r /tmp/claude-tpl/.claude ./
cp /tmp/claude-tpl/.mcp.json ./
rm -rf /tmp/claude-tpl
```

---

## Subagentes (`agents/`)

Los agentes se activan diciendo `use agent <nombre>` o automáticamente según el contexto. Cada uno tiene un rol, stack, reglas de arquitectura y un checklist de errores proactivo.

| Agente | Rol | Cuándo usarlo |
|---|---|---|
| `backend-django` | Backend senior Django 5 + DRF + Celery | Modelos, serializers, ViewSets, tareas async, JWT, multi-tenant |
| `frontend-react` | Frontend senior React 18 + Shadcn/ui | Componentes, páginas, hooks, formularios, rutas protegidas |
| `ai-fraud` | Especialista IA/ML | Pipeline de scoring, LangChain, XGBoost, SHAP, Pinecone |
| `devops-aws` | DevOps + infraestructura | Docker, ECS Fargate, GitHub Actions, RDS, S3, CI/CD |
| `database` | DBA PostgreSQL | Modelos, migraciones, índices, diseño de esquema, multi-tenant |
| `qa-reviewer` | QA senior | Pruebas reales contra la API, integración frontend-backend, cierre de sprint |

### Modos del `qa-reviewer`

```
qa-reviewer modo WATCH   → corre en paralelo mientras codificás
qa-reviewer modo FEATURE → antes de mergear una feature
qa-reviewer modo SPRINT  → gate de cierre de sprint
qa-reviewer modo SYSTEM  → levanta y verifica el sistema completo
```

---

## Slash Commands (`commands/`)

Se invocan escribiendo `/nombre` en el chat de Claude Code.

| Comando | Qué genera |
|---|---|
| `/new-module <nombre>` | Scaffold completo de una app Django (models, serializers, views, urls, tests) |
| `/api-endpoint <modelo> <accion>` | Endpoint DRF completo con serializer, viewset, tests y documentación |
| `/react-component <tipo> <nombre>` | Componente React con TypeScript, Tailwind, hook de datos y tests |
| `/fraud-analysis <componente>` | Código del pipeline de IA (scoring, SHAP, LangChain, Pinecone, Celery) |
| `/test-suite <capa> <objetivo>` | Suite de tests para backend (pytest) o frontend (Vitest) |

---

## Skills (`skills/`)

Skills instalados desde [claude-code-templates](https://aitmpl.com). Cada skill incluye referencias técnicas y scripts automatizados que los agentes usan activamente.

| Skill | Qué aporta | Lo usan |
|---|---|---|
| `senior-backend` | API patterns, security practices, DB optimization guide + api_scaffolder, db_migration_tool, api_load_tester | `backend-django`, `database`, `ai-fraud`, `qa-reviewer` |
| `code-reviewer` | Code review checklist, coding standards, antipatterns + code_quality_checker, pr_analyzer, review_report_generator | Todos los agentes antes de entregar |
| `docker-expert` | Multi-stage builds, security hardening, Compose patterns, checklist de revisión completo | `devops-aws` |
| `senior-frontend` | React patterns, best practices, bundle analyzer, component generator | `frontend-react`, `qa-reviewer` |
| `ui-ux-pro-max` | Paletas de color, tipografía, UX guidelines, stacks react+shadcn, design system validator | `frontend-react` (obligatorio en cambios de UI) |
| `senior-architect` | Architecture patterns, system design workflows, tech decision guide + architecture_diagram_generator, dependency_analyzer | `backend-django`, `devops-aws`, `database`, `ai-fraud` |

### Reinstalar skills en un proyecto nuevo

Si preferís instalarlos desde cero con la última versión:

```bash
npx claude-code-templates@latest --skill development/senior-backend
npx claude-code-templates@latest --skill development/code-reviewer
npx claude-code-templates@latest --skill development/docker-expert
npx claude-code-templates@latest --skill development/senior-frontend
npx claude-code-templates@latest --skill creative-design/ui-ux-pro-max
npx claude-code-templates@latest --skill development/senior-architect
```

---

## Plugin MCP: `code-review-graph`

El plugin más importante de la configuración. Construye un **grafo de conocimiento estructural** del código usando Tree-sitter y permite análisis de impacto, revisión de código eficiente y búsqueda semántica sin leer archivos enteros.

### Configuración

El archivo `.mcp.json` en la raíz del proyecto lo activa automáticamente:

```json
{
  "mcpServers": {
    "code-review-graph": {
      "command": "uvx",
      "args": ["code-review-graph", "serve"]
    }
  }
}
```

Verificar que está conectado:

```bash
claude mcp list
# code-review-graph: uvx code-review-graph serve - ✓ Connected
```

### Herramientas disponibles

| Herramienta | Para qué sirve |
|---|---|
| `build_or_update_graph` | Construye el grafo inicial del proyecto |
| `detect_changes` | Analiza cambios recientes con score de riesgo |
| `get_review_context` | Obtiene snippets relevantes para revisión (token-eficiente) |
| `get_impact_radius` | Muestra el blast radius de un cambio |
| `get_affected_flows` | Encuentra qué flujos de ejecución impacta un cambio |
| `query_graph` | Traza callers, callees, imports, tests de una función |
| `semantic_search_nodes` | Busca funciones/clases por nombre o keyword |
| `get_architecture_overview` | Estructura de alto nivel del proyecto |
| `get_impact_radius` | Impacto de modificar un módulo o función |

### Flujo recomendado (en CLAUDE.md del proyecto)

```
Explorar código    → semantic_search_nodes o query_graph   (no Grep)
Entender impacto   → get_impact_radius                     (no rastrear imports manual)
Code review        → detect_changes + get_review_context   (no leer archivos enteros)
Relaciones         → query_graph callers_of/callees_of     (no buscar referencias manual)
Arquitectura       → get_architecture_overview             (vista rápida)
```

### Requisito

```bash
pip install uv   # o brew install uv
```

---

## Personalizar para tu proyecto

Después de copiar la carpeta `.claude/`, editá:

1. **`agents/*.md`** — adaptá el stack, estructura de carpetas y reglas al nuevo proyecto.
2. **`commands/*.md`** — ajustá los scaffolds al framework que uses.
3. **`settings.json`** — agregá o quitá permisos de Bash según el proyecto.
4. **Creá `.claude/settings.local.json`** con los MCP servers específicos del proyecto.
5. **Creá `CLAUDE.md`** en la raíz con el contexto del proyecto (stack, módulos, convenciones).

---

## Stack base de estos templates

Diseñados para proyectos **Django 5 + React 18**, pero los agentes de `devops-aws`, `database` y `qa-reviewer` son reutilizables en cualquier stack con mínimos ajustes.

| Capa | Tecnología |
|---|---|
| Backend | Python 3.12 · Django 5 · DRF · Celery · Redis |
| Frontend | React 18 · TypeScript · Tailwind · Shadcn/ui · TanStack Query |
| Base de datos | PostgreSQL · Redis · Elasticsearch · Pinecone |
| IA/ML | LangChain · OpenAI · XGBoost · SHAP |
| Infraestructura | Docker · AWS ECS Fargate · RDS · S3 · GitHub Actions |

---

*Maintainer: [@larzekao9](https://github.com/larzekao9)*
