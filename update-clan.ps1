# Correr parado DENTRO de la carpeta pacoAgents, DESPUES de:
#   1. Copiar los 5 archivos nuevos (el-centinela.md, el-notario.md, el-embajador.md,
#      el-inquisidor.md, el-tesorero.md) a .claude\agents\
#   2. Aplicar los parches de PATCHES.md a los 9 agentes existentes en .claude\agents\
#   3. Reemplazar el CLAUDE.md de la raiz del repo por el nuevo que te di
#   4. Tener sir-paco-the-great.agent.md en la raiz del repo (NO dentro de .claude\agents)

# --- 0) Ocultar a los 14 especialistas del dropdown DIRECTAMENTE en el proyecto ---
#     (esto es lo que faltaba: sin esto, Copilot los detecta como "workspace scope"
#     ademas de la copia global, y aparecen duplicados)
Get-ChildItem ".\.claude\agents\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -notmatch "(?m)^user-invocable:") {
        $content = $content -replace "(?s)^---\r?\n", "---`nuser-invocable: false`n"
        Set-Content $_.FullName $content -NoNewline
        Write-Host "Ocultado en el proyecto: $($_.Name)"
    }
}

# --- 1) Actualizar instalacion global de Claude Code (CLI) ---
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude\agents" | Out-Null
Copy-Item ".\.claude\agents\*.md" "$env:USERPROFILE\.claude\agents\" -Force

# OJO: esto REEMPLAZA el CLAUDE.md global entero (no lo agrega con >>).
# Si en ~/.claude/CLAUDE.md tenias algo mas ademas de Sir Paco, hace backup antes.
Copy-Item "$env:USERPROFILE\.claude\CLAUDE.md" "$env:USERPROFILE\.claude\CLAUDE.md.bak" -ErrorAction SilentlyContinue
Copy-Item ".\CLAUDE.md" "$env:USERPROFILE\.claude\CLAUDE.md" -Force

# --- 2) Actualizar instalacion global de Copilot (VS Code) ---
New-Item -ItemType Directory -Force "$env:USERPROFILE\.copilot\agents" | Out-Null

Get-ChildItem ".\.claude\agents\*.md" | ForEach-Object {
    $dest = "$env:USERPROFILE\.copilot\agents\$($_.BaseName).agent.md"
    Copy-Item $_.FullName $dest -Force
    Write-Host "Copilot (oculto del dropdown): $dest"
}

# Sir Paco actualizado y visible en el dropdown (unica fuente: la global)
Copy-Item ".\sir-paco-the-great.agent.md" "$env:USERPROFILE\.copilot\agents\sir-paco-the-great.agent.md" -Force

Write-Host "`nListo. Clan completo (14 especialistas ocultos + Sir Paco visible) actualizado en el proyecto y global."
Write-Host "Reinicia VS Code y tu terminal de Claude Code para que tomen los cambios."
