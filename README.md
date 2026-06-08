# ⚔️ pacoAgents — El Clan de Sir Paco The Great

> Un sistema multiagente para **Claude Code** con temática de clan medieval.
> Sir Paco The Great actúa como Gran Maestre orquestador: recibe tus órdenes, arma la estrategia y delega cada tarea al especialista correcto de su clan.

---

## 📜 Índice

1. [¿Qué es esto?](#-qué-es-esto)
2. [Requisitos previos](#-requisitos-previos)
3. [Instalación rápida (TL;DR)](#-instalación-rápida-tldr)
4. [Instalación paso a paso](#-instalación-paso-a-paso)
5. [El clan](#-el-clan)
6. [Cómo se usa](#-cómo-se-usa)
7. [Cómo funciona por dentro](#-cómo-funciona-por-dentro)
8. [Personalización](#-personalización)
9. [Solución de problemas](#-solución-de-problemas)
10. [Estructura de archivos](#-estructura-de-archivos)

---

## 🏰 ¿Qué es esto?

En vez de que Claude resuelva todo en un solo hilo, **pacoAgents** reparte el trabajo en roles especializados que se activan según la tarea. Cada subagente tiene sus **propias herramientas, su propio modelo y su propio system prompt**, optimizados para su especialidad.

Vos solo le hablás a **Sir Paco**. Él se encarga del resto:

```
Usuario → Sir Paco → Estratega (plan) → Senescal (tareas) → Especialistas → Sir Paco → Usuario
```

**Ventajas de este enfoque:**

- Cada especialista trabaja en su **propio contexto aislado**, así no se mezcla el ruido de una tarea con otra.
- Podés asignar **modelos más baratos** a los roles simples y reservar los caros para lo complejo.
- Las **herramientas están acotadas por rol**: el que investiga no puede romper archivos, el que diseña no toca el servidor, etc.

---

## ✅ Requisitos previos

Antes de instalar, asegurate de tener:

| Requisito | Cómo verificar |
|---|---|
| **Claude Code instalado** | Corré `claude --version` en la terminal. Si da error, instalalo desde [code.claude.com](https://code.claude.com). |
| **Una terminal** | macOS/Linux: app **Terminal**. Windows: **PowerShell**, **Git Bash** o **WSL**. |
| **Los archivos del clan** | La carpeta `pacoAgents/` con su `CLAUDE.md` y la carpeta `.claude/`. |

> 💡 **Si nunca usaste la terminal:** es la ventana de texto donde escribís comandos. Todos los comandos de este README se pegan **ahí**, no dentro del chat de Claude Code ni dentro de un archivo.

---

## ⚡ Instalación rápida (TL;DR)

Si ya sabés moverte en la terminal, esto te deja el clan disponible **en todos tus proyectos**:

```bash
# macOS / Linux — parado dentro de la carpeta pacoAgents
mkdir -p ~/.claude/agents
cp .claude/agents/*.md ~/.claude/agents/
cat CLAUDE.md >> ~/.claude/CLAUDE.md
```

Listo. Abrí Claude Code en cualquier proyecto y escribí una tarea. Si querés entender qué hace cada línea, seguí leyendo. 👇

---

## 🛠️ Instalación paso a paso

Elegí **una** de las dos opciones según dónde querés tener el clan disponible:

| Opción | Cuándo usarla |
|---|---|
| **A — Global** | Querés a Sir Paco en **todos** tus proyectos, sin volver a instalar. |
| **B — Por proyecto** | Querés el clan **solo en un proyecto** puntual. |

### Paso 1 — Abrí la terminal y ubicate

1. Abrí tu terminal.
2. Navegá hasta la carpeta `pacoAgents` (ajustá la ruta a la tuya):

   ```bash
   cd ruta/a/pacoAgents
   ```

3. Confirmá que estás en el lugar correcto. Este comando debe listar los archivos del clan:

   ```bash
   ls .claude/agents
   ```

   Deberías ver: `el-estratega.md`, `el-senescal.md`, `el-maestro-cantero.md`, etc.
   Si en cambio ves *"No such file or directory"*, todavía no estás en la carpeta correcta. Revisá la ruta del paso 2.

---

### Opción A — Instalación global

Disponible en **todos** tus proyectos.

**1. Copiá los agentes a tu directorio global de Claude Code:**

```bash
# macOS / Linux
mkdir -p ~/.claude/agents
cp .claude/agents/*.md ~/.claude/agents/
```

```powershell
# Windows (PowerShell)
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude\agents" | Out-Null
Copy-Item ".\.claude\agents\*.md" "$env:USERPROFILE\.claude\agents\"
```

**2. Dale el mando a Sir Paco globalmente** agregando su persona a tu `CLAUDE.md` global:

```bash
# macOS / Linux
cat CLAUDE.md >> ~/.claude/CLAUDE.md
```

```powershell
# Windows (PowerShell)
Get-Content CLAUDE.md | Add-Content "$env:USERPROFILE\.claude\CLAUDE.md"
```

> ⚠️ **Ojo:** estos comandos **agregan** (`>>`) el contenido al final del archivo global. Si los corrés dos veces, Sir Paco quedará duplicado. Si necesitás reinstalar, abrí `~/.claude/CLAUDE.md` y borrá la copia vieja primero.

---

### Opción B — Instalación por proyecto

El clan vive **solo** en el proyecto que elijas.

```bash
# macOS / Linux — reemplazá la ruta de destino por la de tu proyecto
cp -r .claude/ /ruta/a/tu/proyecto/.claude/
cp CLAUDE.md /ruta/a/tu/proyecto/CLAUDE.md
```

```powershell
# Windows (PowerShell)
Copy-Item -Recurse ".\.claude\" "C:\ruta\a\tu\proyecto\.claude\"
Copy-Item ".\CLAUDE.md" "C:\ruta\a\tu\proyecto\CLAUDE.md"
```

El `CLAUDE.md` en la raíz de ese proyecto activa a Sir Paco **solo ahí**.

> 💡 **Precedencia:** si un día tenés un agente global y otro con el mismo nombre dentro de un proyecto, **gana el del proyecto**. Útil para sobreescribir a un solo miembro del clan en un repo puntual.

---

### Paso final — Verificá que quedó bien

1. Abrí Claude Code dentro de cualquier proyecto:

   ```bash
   claude
   ```

2. Pedí la lista de agentes disponibles:

   ```
   /agents
   ```

   Deberías ver a los miembros del clan (`el-estratega`, `el-senescal`, etc.).

3. Probá una orden real:

   ```
   Sir Paco, construye una landing page con formulario de contacto
   ```

   Sir Paco debería anunciar a qué miembro del clan convoca antes de delegar.

> 🔄 **Importante:** los subagentes se cargan **al iniciar la sesión**. Si copiás o editás archivos con Claude Code abierto, cerralo y volvelo a abrir para que los detecte.

---

## 👑 El clan

| Agente | Rol | Modelo | Herramientas |
|---|---|---|---|
| **Sir Paco The Great** | Gran Maestre orquestador. Único que habla con el usuario. Coordina todo el clan. | *(sesión principal)* | Todas |
| **el-estratega** | Recibe el objetivo y arma el plan de campaña: fases, dependencias, riesgos y criterios de éxito. No ejecuta código. | Opus 4.8 | Read, Grep, Glob |
| **el-senescal** | Toma el plan del Estratega y lo divide en tareas atómicas, asignando cada una al especialista correcto. | Opus 4.8 | Read, Grep, Glob |
| **el-maestro-cantero** | Front-end y web: HTML, CSS, JS, React/Vue/Svelte, componentes, responsive design. | Opus 4.8 | Read, Write, Edit, Bash, Grep, Glob |
| **el-iluminador** | UI/UX: paletas de color, tipografía, sistema de diseño, layouts, componentes visuales. | Opus 4.8 | Read, Write, Edit, Grep, Glob |
| **el-arquitecto-de-bovedas** | Back-end y base de datos: esquemas, modelos, migraciones, lógica de servidor, persistencia. | Opus 4.8 | Read, Write, Edit, Bash, Grep, Glob |
| **el-heraldo** | APIs: endpoints REST/GraphQL, contratos, autenticación, middleware, integraciones externas. | Opus 4.8 | Read, Write, Edit, Bash, Grep, Glob |
| **el-castellano** | Infra/DevOps: Docker, CI/CD, despliegue, variables de entorno, servidores. | Opus 4.8 | Read, Write, Edit, Bash, Grep, Glob |
| **el-cronista** | Investigación: busca documentación, compara librerías, evalúa mejores prácticas. | Opus 4.8 | Read, Grep, Glob, WebSearch, WebFetch |
| **el-fisico** | Diagnóstico de código: bugs, vulnerabilidades, code smells y errores de tipos. Entrega un *Informe Médico* con severidad y tratamiento para cada mal. | Opus 4.8 | Read, Grep, Glob, Bash |

---

## 🎯 Cómo se usa

Una vez instalado, describí tu tarea **en lenguaje natural**. Sir Paco se encarga del resto:

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

```
revisa este archivo en busca de bugs y vulnerabilidades
```

Sir Paco anunciará a cada miembro del clan que convoca y **por qué**, antes de delegarle la tarea.

> 💡 Para tareas chicas (una pregunta puntual, una corrección menor), Sir Paco puede responder directamente sin convocar a todo el clan.

---

## ⚙️ Cómo funciona por dentro

**Ejemplo:** `"construye una app de tareas con login"`

```
Sir Paco recibe la orden
  │
  ├─► el-estratega
  │     Analiza el objetivo y devuelve el plan:
  │     · Fase 1: Infraestructura de datos (schema, auth)
  │     · Fase 2: API (endpoints CRUD + auth)
  │     · Fase 3: Front-end (UI + integración)
  │     · Fase 4: Despliegue
  │     · Riesgo a decidir: JWT vs sessions
  │
  ├─► el-senescal
  │     Divide el plan en tareas atómicas y las asigna:
  │     T1 → el-cronista          (comparar Prisma vs Drizzle)
  │     T2 → el-arquitecto        (schema users/tasks + migraciones)
  │     T3 → el-heraldo           (POST /register, POST /login, JWT)
  │     T4 → el-heraldo           (CRUD /tasks)
  │     T5 → el-iluminador        (sistema de diseño: paleta, componentes)
  │     T6 → el-maestro-cantero   (páginas Login y Register)
  │     T7 → el-maestro-cantero   (Dashboard + lista de tareas)
  │     T8 → el-castellano        (Dockerfile + docker-compose + .env.example)
  │     T9 → el-castellano        (GitHub Actions CI)
  │
  ├─► el-cronista        → "Usar Drizzle: menor overhead, mejor DX en TypeScript"
  ├─► el-arquitecto      → schema + migraciones escritas
  ├─► el-heraldo         → endpoints con auth JWT implementados
  ├─► el-iluminador      → tokens CSS + guía de componentes
  ├─► el-maestro-cantero → páginas React completas
  ├─► el-castellano      → Docker + CI configurados
  │
  └─► Sir Paco integra todo y reporta al usuario con pompa y solemnidad
```

---

## 🎨 Personalización

### Cambiar el modelo de un agente

Editá el frontmatter del archivo `.md` correspondiente. Por ejemplo, para hacer al Cantero más rápido y barato:

```yaml
---
name: el-maestro-cantero
model: claude-haiku-4-5-20251001
---
```

**Modelos disponibles:**

| Modelo | Cuándo conviene |
|---|---|
| `claude-opus-4-8` | Máxima capacidad. Ideal para planeación y back-end complejo. *(por defecto en este clan)* |
| `claude-sonnet-4-6` | Buen balance velocidad/capacidad. Buena opción para la mayoría de los especialistas. |
| `claude-haiku-4-5-20251001` | El más rápido y económico. Bueno para tareas simples o de alto volumen. |

> 💰 **Tip de costos:** tener todo el clan en Opus 4.8 es potente pero caro. Una configuración equilibrada típica: **Opus** para `el-estratega`, `el-senescal` y `el-arquitecto-de-bovedas`; **Sonnet** para el resto; **Haiku** para tareas muy repetitivas.

### Cambiar el modelo de Sir Paco (sesión principal)

Dentro de Claude Code:

```
/model claude-opus-4-8
```

### Agregar un nuevo especialista

1. Creá un archivo en `.claude/agents/` (global o de proyecto) con este formato:

   ```markdown
   ---
   name: nombre-del-agente
   description: Cuándo usarlo. Incluí "usar proactivamente" para fomentar la delegación automática.
   tools: Read, Write, Edit, Bash, Grep, Glob
   model: claude-opus-4-8
   ---

   Acá va el system prompt del agente, con su voz de clan medieval.
   ```

2. Mencionalo en el `CLAUDE.md` para que Sir Paco sepa cuándo convocarlo.
3. Reiniciá la sesión de Claude Code para que lo cargue.

---

## 🩺 Solución de problemas

| Síntoma | Causa probable | Solución |
|---|---|---|
| `No such file or directory` al copiar | No estás parado en la carpeta `pacoAgents`. | Volvé a la carpeta con `cd` y verificá con `ls .claude/agents`. |
| `/agents` no muestra al clan | Los archivos no quedaron en la ubicación correcta, o la sesión estaba abierta al copiarlos. | Verificá con `ls ~/.claude/agents` (global) y reiniciá Claude Code. |
| Sir Paco no aparece / no orquesta | El `CLAUDE.md` no se cargó. | Confirmá que existe en `~/.claude/CLAUDE.md` (global) o en la raíz del proyecto. |
| Sir Paco aparece dos veces / instrucciones duplicadas | Corriste el `cat ... >>` más de una vez. | Abrí `~/.claude/CLAUDE.md` y borrá la copia repetida. |
| Sir Paco delega al miembro equivocado | La `description` de algún agente es ambigua. | Editá el campo `description` del agente para que sea más específico. |
| Los comandos de PowerShell dan error en Mac/Linux (o al revés) | Estás usando los comandos del otro sistema operativo. | Usá el bloque correcto según tu sistema. |

> 🔄 Recordá: **casi cualquier cambio en los agentes requiere reiniciar la sesión** de Claude Code para que tome efecto.

---

## 📂 Estructura de archivos

```
pacoAgents/
├── README.md                              ← este archivo
├── CLAUDE.md                              ← Sir Paco The Great (el orquestador)
└── .claude/
    └── agents/
        ├── el-estratega.md
        ├── el-senescal.md
        ├── el-maestro-cantero.md
        ├── el-iluminador.md
        ├── el-arquitecto-de-bovedas.md
        ├── el-heraldo.md
        ├── el-castellano.md
        ├── el-cronista.md
        └── el-fisico.md
```

---

## 📝 Notas finales

- Los subagentes solo acceden a las herramientas listadas en su campo `tools:`. Si uno necesita algo fuera de su dominio, Sir Paco delega a otro miembro.
- **el-cronista** es el único con acceso a `WebSearch` y `WebFetch`: convocalo siempre que haga falta información externa.
- Para que un especialista acumule aprendizaje entre proyectos, podés agregarle `memory: user` en su frontmatter y tendrá un directorio persistente propio.
- Si vas a compartir el clan con tu equipo, considerá empaquetarlo como **plugin** de Claude Code en vez de copiar archivos a mano.

---

*Que la forja nunca se apague. ⚒️*
