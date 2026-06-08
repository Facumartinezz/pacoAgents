# pacoAgents — El Clan de Sir Paco The Great

Sistema multiagente para Claude Code con temática de clan medieval. Sir Paco The Great actúa como Gran Maestre orquestador y delega automáticamente cada tarea al especialista correcto de su clan.

---

## ¿Qué hace?

En vez de que Claude resuelva todo solo, **pacoAgents** divide el trabajo en roles especializados que se activan según la tarea. Cada subagente tiene herramientas, modelo y system prompt propios, optimizados para su especialidad.

El flujo siempre es:

```
Usuario → Sir Paco → Estratega (plan) → Senescal (tareas) → Especialistas → Sir Paco → Usuario
```

---

## El clan

| Agente | Rol | Modelo | Herramientas |
|---|---|---|---|
| **Sir Paco The Great** | Gran Maestre orquestador. Único que habla con el usuario. Coordina todo el clan. | *(sesión principal)* | Todas |
| **el-estratega** | Recibe el objetivo y produce el plan de campaña: fases, dependencias, riesgos y criterios de éxito. No ejecuta código. | Opus 4.8 | Read, Grep, Glob |
| **el-senescal** | Toma el plan del Estratega y lo divide en tareas atómicas, asignando cada una al especialista correcto. | Opus 4.8 | Read, Grep, Glob |
| **el-maestro-cantero** | Front-end y web: HTML, CSS, JS, React/Vue/Svelte, componentes, responsive design. | Opus 4.8 | Read, Write, Edit, Bash, Grep, Glob |
| **el-iluminador** | UI/UX: paletas de color, tipografía, sistema de diseño, layouts, componentes visuales. | Opus 4.8 | Read, Write, Edit, Grep, Glob |
| **el-arquitecto-de-bovedas** | Back-end y base de datos: esquemas, modelos, migraciones, lógica de servidor, persistencia. | Opus 4.8 | Read, Write, Edit, Bash, Grep, Glob |
| **el-heraldo** | APIs: endpoints REST/GraphQL, contratos, autenticación, middleware, integraciones externas. | Opus 4.8 | Read, Write, Edit, Bash, Grep, Glob |
| **el-castellano** | Infra/DevOps: Docker, CI/CD, despliegue, variables de entorno, servidores. | Opus 4.8 | Read, Write, Edit, Bash, Grep, Glob |
| **el-cronista** | Investigación: busca documentación, compara librerías, evalúa mejores prácticas. | Opus 4.8 | Read, Grep, Glob, WebSearch, WebFetch |

---

## Instalación

### Opción A — Global (disponible en todos tus proyectos)

Copia los archivos de agentes a tu directorio global de Claude Code:

```bash
# macOS / Linux
cp -r .claude/agents/* ~/.claude/agents/

# Windows (PowerShell)
Copy-Item -Recurse .\.claude\agents\* "$env:USERPROFILE\.claude\agents\"
```

Para que Sir Paco también tome el mando globalmente, agrega el contenido de `CLAUDE.md` a tu `~/.claude/CLAUDE.md` existente (o créalo si no existe):

```bash
# macOS / Linux
cat CLAUDE.md >> ~/.claude/CLAUDE.md

# Windows (PowerShell)
Get-Content CLAUDE.md | Add-Content "$env:USERPROFILE\.claude\CLAUDE.md"
```

> **Nota:** Con la instalación global, Sir Paco orquestará en cualquier proyecto donde abras Claude Code.

---

### Opción B — Solo en un proyecto específico

Copia la carpeta `.claude/` completa a la raíz del proyecto donde quieras usar el clan:

```bash
# macOS / Linux
cp -r .claude/ /ruta/a/tu/proyecto/
cp CLAUDE.md /ruta/a/tu/proyecto/CLAUDE.md

# Windows (PowerShell)
Copy-Item -Recurse .\.claude\ "C:\ruta\a\tu\proyecto\"
Copy-Item .\CLAUDE.md "C:\ruta\a\tu\proyecto\CLAUDE.md"
```

El `CLAUDE.md` en la raíz del proyecto activa a Sir Paco solo para ese proyecto.

---

### Verificar la instalación

Abre Claude Code en el proyecto y escribe cualquier tarea técnica. Deberías ver a Sir Paco anunciar que convoca a su clan antes de delegar. También puedes verificar que los agentes están disponibles:

```
/agents
```

---

## Uso

Una vez instalado, simplemente describe tu tarea en lenguaje natural. Sir Paco se encarga del resto:

```
construye una landing page para una startup de fintech con login
```

```
agrega autenticación con Google OAuth al proyecto actual
```

```
dockeriza esta app y configura un pipeline de CI en GitHub Actions
```

```
¿qué ORM debería usar para este proyecto? compara las opciones
```

Sir Paco anunciará a cada miembro del clan que convoca y por qué, antes de delegar la tarea.

---

## Flujo detallado — ejemplo real

**Tarea:** `"construye una app de tareas con login"`

```
Sir Paco recibe la orden
  │
  ├─► el-estratega
  │     Analiza el objetivo y devuelve:
  │     - Fase 1: Infraestructura de datos (schema, auth)
  │     - Fase 2: API (endpoints CRUD + auth)
  │     - Fase 3: Front-end (UI + integración)
  │     - Fase 4: Despliegue
  │     - Riesgo: decidir JWT vs sessions
  │
  ├─► el-senescal
  │     Divide el plan en tareas atómicas:
  │     T1 → el-cronista        (comparar Prisma vs Drizzle)
  │     T2 → el-arquitecto      (schema users/tasks + migraciones)
  │     T3 → el-heraldo         (POST /register, POST /login, JWT middleware)
  │     T4 → el-heraldo         (GET/POST/PATCH/DELETE /tasks)
  │     T5 → el-iluminador      (sistema de diseño: paleta, componentes)
  │     T6 → el-maestro-cantero (páginas Login y Register)
  │     T7 → el-maestro-cantero (Dashboard + lista de tareas)
  │     T8 → el-castellano      (Dockerfile + docker-compose + .env.example)
  │     T9 → el-castellano      (GitHub Actions CI)
  │
  ├─► el-cronista      → "Usar Drizzle: menor overhead, mejor TypeScript DX"
  ├─► el-arquitecto    → schema + migraciones escritas
  ├─► el-heraldo       → endpoints implementados con auth JWT
  ├─► el-iluminador    → tokens CSS + guía de componentes
  ├─► el-maestro-cantero → páginas React completas
  ├─► el-castellano    → Docker + CI configurados
  │
  └─► Sir Paco integra todo y reporta al usuario con pompa y solemnidad
```

---

## Estructura de archivos

```
pacoAgents/
├── README.md
├── CLAUDE.md                              ← Sir Paco The Great
└── .claude/
    └── agents/
        ├── el-estratega.md
        ├── el-senescal.md
        ├── el-maestro-cantero.md
        ├── el-iluminador.md
        ├── el-arquitecto-de-bovedas.md
        ├── el-heraldo.md
        ├── el-castellano.md
        └── el-cronista.md
```

---

## Personalización

### Cambiar el modelo de un agente

Edita el frontmatter del archivo `.md` correspondiente:

```yaml
---
name: el-maestro-cantero
model: claude-haiku-4-5-20251001   # más rápido y económico
---
```

Modelos disponibles en Claude Code:
- `claude-opus-4-8` — más capaz (por defecto en este clan)
- `claude-sonnet-4-6` — balance velocidad/capacidad
- `claude-haiku-4-5-20251001` — más rápido y económico

### Agregar un nuevo especialista

Crea un nuevo archivo en `.claude/agents/` con este formato:

```markdown
---
name: nombre-del-agente
description: Cuándo usarlo. Incluye "usar proactivamente" para fomentar delegación automática.
tools: Read, Write, Edit, Bash, Grep, Glob
model: claude-opus-4-8
---

System prompt del agente aquí.
```

Luego menciona al nuevo especialista en el `CLAUDE.md` para que Sir Paco sepa cuándo convocarlo.

### Cambiar el modelo de la sesión principal

En la terminal de Claude Code:

```
/model claude-opus-4-8
```

---

## Notas

- Los subagentes solo tienen acceso a las herramientas listadas en su `tools:`. Si un agente necesita hacer algo fuera de su dominio, Sir Paco debe delegar a otro miembro del clan.
- El Cronista es el único con acceso a `WebSearch` y `WebFetch`. Siempre convócalo cuando se necesite información externa.
- Para tareas simples (una pregunta, una corrección pequeña), Sir Paco puede responder directamente sin necesidad de convocar al clan completo.
