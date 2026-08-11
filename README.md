# ⚔️ pacoAgents — El Clan de Sir Paco The Great

> Un sistema multiagente para **Claude Code** (y GitHub Copilot en VS Code) con temática de clan medieval.
> Sir Paco The Great actúa como Gran Maestre orquestador: recibe tus órdenes, arma la estrategia y delega cada tarea al especialista correcto de su clan de 14 miembros.

---

## 📜 Índice

1. [¿Qué es esto?](#-qué-es-esto)
2. [Requisitos previos](#-requisitos-previos)
3. [Descargar el repositorio correctamente](#-descargar-el-repositorio-correctamente)
4. [Instalación rápida (TL;DR)](#-instalación-rápida-tldr)
5. [Instalación paso a paso](#-instalación-paso-a-paso)
6. [Uso con GitHub Copilot en VS Code](#-uso-con-github-copilot-en-vs-code)
7. [El clan](#-el-clan)
8. [Cómo se usa](#-cómo-se-usa)
9. [Cómo funciona por dentro](#-cómo-funciona-por-dentro)
10. [Personalización](#-personalización)
11. [Solución de problemas](#-solución-de-problemas)
12. [Estructura de archivos](#-estructura-de-archivos)

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
- Funciona tanto en la **terminal con Claude Code** como en **VS Code con GitHub Copilot Chat** (que detecta el mismo formato de agentes).

---

## ✅ Requisitos previos

Antes de instalar, asegurate de tener:

| Requisito | Cómo verificar |
|---|---|
| **Claude Code instalado** | Corré `claude --version` en la terminal. Si da error, instalalo desde [code.claude.com](https://code.claude.com). |
| **Una terminal** | macOS/Linux: app **Terminal**. Windows: **PowerShell**, **Git Bash** o **WSL**. |
| **Git** (recomendado) | Corré `git --version`. Si no lo tenés, instalalo desde [git-scm.com](https://git-scm.com/downloads) — evita el problema de carpetas duplicadas que explico abajo. |
| **Los archivos del clan** | La carpeta `pacoAgents/` con su `CLAUDE.md` y la carpeta `.claude/`. |

> 💡 **Si nunca usaste la terminal:** es la ventana de texto donde escribís comandos. Todos los comandos de este README se pegan **ahí**, no dentro del chat de Claude Code ni dentro de un archivo.

---

## 📥 Descargar el repositorio correctamente

Hay dos formas de bajar este repo. Una te ahorra problemas, la otra es la causa más común de que la instalación falle.

### Opción recomendada: clonar con git

```powershell
cd C:\Users\TuUsuario\Desktop
git clone https://github.com/Facumartinezz/pacoAgents.git
cd pacoAgents
dir
```

Deberías ver directamente `CLAUDE.md`, `README.md` y la carpeta `.claude` en ese nivel.

### Opción alternativa: descargar el ZIP desde GitHub

Si usás el botón **Code → Download ZIP**, GitHub suele generar una carpeta con el nombre repetido al extraerla (por ejemplo `pacoAgents-main\pacoAgents-main\...` o `pacoAgents\pacoAgents\...`). Si corrés los comandos de instalación un nivel más arriba de la cuenta, vas a ver errores como:

```
No se encuentra la ruta de acceso '...\.claude\agents' porque no existe.
```

**Cómo verificarlo:** después de extraer el ZIP, corré `dir` en la carpeta donde estás parado. Si no ves `CLAUDE.md` ni `.claude` directamente, entrá un nivel más:

```powershell
dir -Recurse -Depth 2 -Force
cd pacoAgents   # o el nombre de la subcarpeta que apareció
dir             # confirmá que ahora sí ves CLAUDE.md y .claude
```

---

## ⚡ Instalación rápida (TL;DR)

Si ya sabés moverte en la terminal, esto te deja el clan disponible **en todos tus proyectos**:

```bash
# macOS / Linux — parado dentro de la carpeta pacoAgents
mkdir -p ~/.claude/agents
cp .claude/agents/*.md ~/.claude/agents/
cat CLAUDE.md >> ~/.claude/CLAUDE.md
```

```powershell
# Windows (PowerShell) — parado dentro de la carpeta pacoAgents
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude\agents" | Out-Null
Copy-Item ".\.claude\agents\*.md" "$env:USERPROFILE\.claude\agents\"
Get-Content CLAUDE.md | Add-Content "$env:USERPROFILE\.claude\CLAUDE.md"
```

Listo. Abrí Claude Code en cualquier proyecto y escribí una tarea. Si querés entender qué hace cada línea, seguí leyendo. 👇

> ⚠️ En Windows, para correr un script `.ps1` que descargaste tenés que llamarlo con `.\nombre-del-script.ps1` (no alcanza con escribir el nombre solo). Si PowerShell dice que la ejecución de scripts está deshabilitada, corré una vez `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` antes.

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

   Deberías ver 14 archivos: `el-estratega.md`, `el-senescal.md`, `el-maestro-cantero.md`, `el-iluminador.md`, `el-arquitecto-de-bovedas.md`, `el-heraldo.md`, `el-castellano.md`, `el-cronista.md`, `el-fisico.md`, `el-centinela.md`, `el-notario.md`, `el-embajador.md`, `el-inquisidor.md`, `el-tesorero.md`.
   Si en cambio ves *"No such file or directory"*, todavía no estás en la carpeta correcta — revisá la sección [Descargar el repositorio correctamente](#-descargar-el-repositorio-correctamente).

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

> ⚠️ **Ojo:** estos comandos **agregan** (`>>` / `Add-Content`) el contenido al final del archivo global. Si los corrés dos veces, Sir Paco quedará duplicado. Si necesitás reinstalar, abrí `~/.claude/CLAUDE.md` (o `$env:USERPROFILE\.claude\CLAUDE.md`) y borrá la copia vieja primero, o directamente reemplazá el archivo entero por el `CLAUDE.md` del repo.

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

   Deberías ver a los 14 miembros del clan.

3. Probá una orden real:

   ```
   Sir Paco, construye una landing page con formulario de contacto
   ```

   Sir Paco debería anunciar a qué miembro del clan convoca antes de delegar.

> 🔄 **Importante:** los subagentes se cargan **al iniciar la sesión**. Si copiás o editás archivos con Claude Code abierto, cerralo y volvelo a abrir para que los detecte.

---

## 🖥️ Uso con GitHub Copilot en VS Code

VS Code detecta automáticamente los archivos de `.claude/agents/` y `CLAUDE.md` y los usa también dentro de **GitHub Copilot Chat**, pero hay tres cosas a configurar para que la experiencia sea limpia.

### 1. Que solo aparezca Sir Paco en el dropdown de agentes

Los 14 especialistas quedan disponibles como subagentes que Sir Paco invoca solo — no hace falta verlos en el selector. Para ocultarlos, agregá `user-invocable: false` en el frontmatter de cada uno de los 14 archivos (tanto en el proyecto como en tu carpeta global de Copilot). Sir Paco en sí no es un subagente — para que aparezca como una opción propia en el dropdown, necesita existir como un `.agent.md` con su persona completa y la lista de agentes que puede invocar (`agents: [...]`).

### 2. Instalación global para Copilot

Copilot busca agentes de usuario en `~/.copilot/agents` (no en `~/.claude/agents`, que es solo para Claude Code). Para tenerlos disponibles en todos tus proyectos dentro de VS Code:

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.copilot\agents" | Out-Null

Get-ChildItem ".\.claude\agents\*.md" | ForEach-Object {
    Copy-Item $_.FullName "$env:USERPROFILE\.copilot\agents\$($_.BaseName).agent.md"
}
```

Y copiá también un archivo `sir-paco-the-great.agent.md` (con su persona + `agents: [...]` listando a los 14) a esa misma carpeta, para que aparezca como la única opción visible.

> ⚠️ Si tenés los agentes tanto en `.claude/agents` del proyecto como en `~/.copilot/agents`, Copilot los va a mostrar **duplicados** (una entrada por cada ubicación). Aplicá `user-invocable: false` en **ambas** copias, no solo en una.

### 3. Usar modelos Claude en vez del modelo por defecto de Copilot

Si tenés un plan de Copilot con acceso a modelos Claude, fijá el modelo en el frontmatter de cada `.agent.md` con el nombre **exacto** que te muestra el selector de modelos del chat (por ejemplo `Claude Opus 4.5`, `Claude Sonnet 4.5`, `Claude Haiku 4.5` — puede variar según tu plan):

```yaml
---
name: el-estratega
model: 'Claude Opus 4.5'
---
```

Reservá Opus para los roles de mayor razonamiento (el-estratega, el-senescal, el-arquitecto-de-bovedas, el-inquisidor, y Sir Paco), Sonnet para la mayoría de la ejecución, y Haiku para lo más mecánico (el-embajador).

---

## 👑 El clan

Sir Paco lidera un clan de 14 especialistas, cada uno con dominio, herramientas y modelo propios.

| Agente | Rol | Modelo sugerido | Herramientas |
|---|---|---|---|
| **Sir Paco The Great** | Gran Maestre orquestador. Único que habla con el usuario. | *(el mejor disponible)* | Todas / `agent` |
| **el-estratega** | Arma el plan de campaña completo antes de ejecutar nada. | Opus | Read, Grep, Glob |
| **el-senescal** | Divide el plan en tareas atómicas y las asigna. | Opus | Read, Grep, Glob |
| **el-maestro-cantero** | Front-end: HTML, CSS, JS, componentes, responsive. | Sonnet | Read, Write, Edit, Bash, Grep, Glob |
| **el-iluminador** | UI/UX: paletas, tipografía, sistema de diseño. | Sonnet | Read, Write, Edit, Grep, Glob |
| **el-arquitecto-de-bovedas** | Back-end y base de datos: esquemas, migraciones, lógica de servidor. | Opus | Read, Write, Edit, Bash, Grep, Glob |
| **el-heraldo** | APIs REST/GraphQL: endpoints, contratos, auth, integraciones. | Sonnet | Read, Write, Edit, Bash, Grep, Glob |
| **el-castellano** | Infra/DevOps: Docker, CI/CD, despliegue, variables de entorno. | Sonnet | Read, Write, Edit, Bash, Grep, Glob |
| **el-cronista** | Investigación: documentación, comparación de librerías. | Sonnet | Read, Grep, Glob, WebSearch, WebFetch |
| **el-fisico** | Diagnóstico de bugs, vulnerabilidades y code smells. | Sonnet | Read, Grep, Glob, Bash |
| **el-centinela** | Testing y QA: tests unitarios, integración, e2e. | Sonnet | Read, Write, Edit, Bash, Grep, Glob |
| **el-notario** | Documentación: README, comentarios, changelogs, docs de API. | Sonnet | Read, Write, Edit, Grep, Glob |
| **el-embajador** | Git: commits, Pull Requests, resolución de conflictos. | Haiku | Read, Bash, Grep, Glob |
| **el-inquisidor** | Auditoría de seguridad: secrets, dependencias, auth. | Opus | Read, Grep, Glob, Bash, WebFetch |
| **el-tesorero** | Optimización de costos: APIs pagas, bundle size, imágenes Docker. | Sonnet | Read, Grep, Glob, Bash |

### Detalle de cada miembro

**Sir Paco The Great** — el Gran Maestre. Nunca escribe código ni toca archivos: recibe tu pedido, convoca a el-estratega para el plan, a el-senescal para dividirlo en tareas, y delega cada una al especialista correcto. Al final integra todo y te reporta con su pompa característica.

**El Estratega** — antes de que se mueva una sola piedra, traza el mapa completo: fases secuenciales, dependencias, riesgos técnicos y criterios de éxito verificables. No ejecuta ni escribe código, solo piensa la campaña completa. Ahora también se asegura de incluir explícitamente fases de testing, documentación y seguridad cuando la tarea las amerita.

**El Senescal** — toma el plan del Estratega y lo convierte en tareas atómicas y asignadas, respetando dependencias y señalando qué puede hacerse en paralelo. Conoce el dominio de los 14 especialistas y sabe exactamente a quién asignarle cada tarea.

**El Maestro Cantero** — construye la fachada visible: componentes HTML/CSS/JS, integración con React/Vue/Svelte, maquetado responsive y accesible. Aplica mobile-first, semántica correcta y performance (lazy loading, code splitting). Coordina con el-iluminador para estilos y con el-centinela cuando el componente tiene lógica no trivial.

**El Iluminador** — define el sistema visual: paletas de color con contraste accesible (WCAG), tipografía, layout, y componentes UI completos en todos sus estados (hover, focus, disabled, error). Entrega tokens de diseño listos para que el Maestro Cantero los implemente.

**El Arquitecto de Bóvedas** — diseña el modelo de datos: entidades, relaciones, migraciones reversibles, capa de persistencia y lógica de servidor. Prioriza integridad, seguridad por diseño (sin SQL injection, sin secrets en logs) y separación de capas. Si el esquema incluye datos sensibles, deriva a el-inquisidor para revisión.

**El Heraldo** — diseña e implementa APIs: rutas, schemas de entrada/salida, códigos de estado, autenticación y rate limiting. Cada endpoint lleva contrato explícito y manejo de errores informativo. Documenta el contrato final para que el-notario lo integre, y deriva a el-inquisidor cuando hay auth o datos sensibles de por medio.

**El Castellano** — mantiene la infraestructura en pie: contenedores Docker, pipelines CI/CD, gestión de secrets, servidores y cloud. Aplica inmutabilidad, mínimo privilegio y reproducibilidad total. Antes de cualquier deploy a producción, recomienda pasar por el-inquisidor y, si detecta sobreaprovisionamiento, deriva a el-tesorero.

**El Cronista** — el único con acceso a búsqueda web. Investiga documentación oficial, compara librerías con evidencia y entrega recomendaciones accionables con fuentes citadas y fechadas, nunca listas de links sin conclusión.

**El Físico** — diagnostica bugs, vulnerabilidades, errores de tipos y code smells, corriendo linters y type checkers reales del proyecto. Entrega un "Informe Médico" con severidad (crítico/moderado/leve), evidencia y el fix exacto para cada hallazgo. Si detecta algo específicamente de seguridad, lo deriva a el-inquisidor.

**El Centinela** *(nuevo)* — escribe y corre tests (unitarios, integración, e2e) antes de que algo llegue a producción. Prueba comportamiento, no implementación; prioriza casos límite y tests deterministas. Es guardia obligatoria antes de cualquier deploy, junto con el-inquisidor.

**El Notario** *(nuevo)* — mantiene README, comentarios, changelogs y documentación de API al día tras cada cambio significativo. Escribe para quien no tiene contexto de la conversación, con ejemplos que realmente funcionan tal cual están escritos.

**El Embajador** *(nuevo)* — redacta mensajes de commit y descripciones de Pull Request, y resuelve conflictos de merge entendiendo ambos lados antes de decidir. Nunca hace `push --force` ni reescribe historia compartida sin confirmación explícita.

**El Inquisidor** *(nuevo)* — auditoría de seguridad dedicada: secrets expuestos, dependencias con CVEs, inyección, autenticación mal ubicada, exposición de datos. Se activa antes de cualquier deploy, al tocar autenticación/datos sensibles, o al agregar dependencias nuevas.

**El Tesorero** *(nuevo)* — revisa gasto evitable: llamadas a APIs pagas, imágenes Docker infladas, bundle size, queries N+1. Mide antes de recomendar y nunca sacrifica seguridad o corrección solo por ahorrar.

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

```
prepará un Pull Request con estos cambios
```

Sir Paco anunciará a cada miembro del clan que convoca y **por qué**, antes de delegarle la tarea.

> 💡 Para tareas chicas (una pregunta puntual, una corrección menor), Sir Paco puede responder directamente sin convocar a todo el clan.

---

## ⚙️ Cómo funciona por dentro

**Ejemplo:** `"construye una app de tareas con login y prepará el deploy"`

```
Sir Paco recibe la orden
  │
  ├─► el-estratega
  │     Fase 1: Datos y auth · Fase 2: API · Fase 3: Front-end
  │     Fase 4: Testing y seguridad · Fase 5: Despliegue
  │
  ├─► el-senescal
  │     Asigna cada tarea al especialista correspondiente
  │
  ├─► el-cronista        → compara Prisma vs Drizzle
  ├─► el-arquitecto       → schema + migraciones
  ├─► el-heraldo          → endpoints con auth JWT
  ├─► el-iluminador       → tokens CSS + guía de componentes
  ├─► el-maestro-cantero  → páginas Login/Register/Dashboard
  ├─► el-centinela        → tests de la lógica de auth y CRUD
  ├─► el-inquisidor       → revisión de seguridad antes del deploy
  ├─► el-castellano       → Docker + CI configurados
  ├─► el-notario          → README y changelog actualizados
  ├─► el-embajador        → commit y descripción de PR
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

**Modelos disponibles (Claude Code):**

| Modelo | Cuándo conviene |
|---|---|
| `opus` | Máxima capacidad. Ideal para planeación, arquitectura y seguridad. |
| `sonnet` | Buen balance velocidad/capacidad. Buena opción para la mayoría de los especialistas. |
| `haiku` | El más rápido y económico. Bueno para tareas simples o de alto volumen. |

> 💰 **Tip de costos:** una configuración equilibrada típica: **Opus** para `el-estratega`, `el-senescal`, `el-arquitecto-de-bovedas` e `el-inquisidor`; **Sonnet** para el resto; **Haiku** para `el-embajador`.

Si usás Copilot en VS Code, mirá la sección [Uso con GitHub Copilot en VS Code](#-uso-con-github-copilot-en-vs-code) — el formato del campo `model` es distinto ahí (nombre completo del modelo tal como aparece en el selector de Copilot).

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
   model: opus
   ---

   Acá va el system prompt del agente, con su voz de clan medieval.
   ```

2. Mencionalo en el `CLAUDE.md` (flujo de delegación + sección "Cuándo invocar a...") para que Sir Paco sepa cuándo convocarlo.
3. Si usás Copilot, agregalo también a `~/.copilot/agents` como `.agent.md`, con `user-invocable: false`, y sumalo a la lista `agents: [...]` de `sir-paco-the-great.agent.md`.
4. Reiniciá la sesión de Claude Code (y VS Code si aplica) para que lo cargue.

---

## 🩺 Solución de problemas

| Síntoma | Causa probable | Solución |
|---|---|---|
| `No such file or directory` al copiar | No estás parado en la carpeta `pacoAgents`, o descargaste el ZIP y quedó una carpeta anidada (`pacoAgents\pacoAgents`). | Volvé a la carpeta con `cd` y verificá con `ls .claude/agents` / `dir .claude\agents`. Ver [Descargar el repositorio correctamente](#-descargar-el-repositorio-correctamente). |
| `.ps1 no se reconoce como cmdlet...` | En PowerShell hay que anteponer `.\` al nombre del script, o el archivo no está en la carpeta donde estás parado. | Corré `.\nombre-del-script.ps1`. Si sigue fallando, corré `dir *.ps1` para confirmar que el archivo realmente está ahí. |
| PowerShell dice que la ejecución de scripts está deshabilitada | Política de ejecución restrictiva por defecto en Windows. | Corré `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` antes de ejecutar el script. |
| `/agents` no muestra al clan | Los archivos no quedaron en la ubicación correcta, o la sesión estaba abierta al copiarlos. | Verificá con `ls ~/.claude/agents` (global) y reiniciá Claude Code. |
| Sir Paco no aparece / no orquesta | El `CLAUDE.md` no se cargó. | Confirmá que existe en `~/.claude/CLAUDE.md` (global) o en la raíz del proyecto. |
| Sir Paco aparece dos veces / instrucciones duplicadas | Corriste el `cat ... >>` / `Add-Content` más de una vez. | Abrí `~/.claude/CLAUDE.md` y borrá la copia repetida, o reemplazá el archivo entero. |
| En Copilot (VS Code) aparecen todos los especialistas en el dropdown, no solo Sir Paco | Los agentes no tienen `user-invocable: false`, o Sir Paco no existe como `.agent.md` propio. | Ver [Uso con GitHub Copilot en VS Code](#-uso-con-github-copilot-en-vs-code). |
| En Copilot los agentes aparecen **duplicados** | Los tenés visibles tanto en `.claude/agents` del proyecto como en `~/.copilot/agents` global. | Aplicá `user-invocable: false` en **ambas** ubicaciones, no solo en una. |
| Sir Paco delega al miembro equivocado | La `description` de algún agente es ambigua. | Editá el campo `description` del agente para que sea más específico. |
| Los comandos de PowerShell dan error en Mac/Linux (o al revés) | Estás usando los comandos del otro sistema operativo. | Usá el bloque correcto según tu sistema. |

> 🔄 Recordá: **casi cualquier cambio en los agentes requiere reiniciar la sesión** de Claude Code (o VS Code) para que tome efecto.

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
        ├── el-fisico.md
        ├── el-centinela.md
        ├── el-notario.md
        ├── el-embajador.md
        ├── el-inquisidor.md
        └── el-tesorero.md
```

---

## 📝 Notas finales

- Los subagentes solo acceden a las herramientas listadas en su campo `tools:`. Si uno necesita algo fuera de su dominio, Sir Paco delega a otro miembro.
- **el-cronista** es el único con acceso a `WebSearch` y `WebFetch`: convocalo siempre que haga falta información externa.
- Para que un especialista acumule aprendizaje entre proyectos, podés agregarle `memory: user` en su frontmatter y tendrá un directorio persistente propio.
- Si vas a compartir el clan con tu equipo, considerá empaquetarlo como **plugin** de Claude Code en vez de copiar archivos a mano.

---

*Que la forja nunca se apague. ⚒️*
