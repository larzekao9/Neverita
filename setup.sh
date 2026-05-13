#!/bin/bash
# setup.sh — Instala la configuración de Claude Code en el proyecto actual
# Uso: ./setup.sh [ruta-destino]   (por defecto: directorio actual)

TARGET="${1:-.}"

echo "Instalando Claude Code templates en: $TARGET"

cp -r .claude "$TARGET/"
cp .mcp.json "$TARGET/"

echo "✓ Agentes, commands y skills copiados"
echo "✓ .mcp.json copiado (code-review-graph MCP)"
echo ""
echo "Próximos pasos:"
echo "  1. Editar .claude/agents/*.md para adaptar el stack del proyecto"
echo "  2. Crear .claude/settings.local.json si el proyecto necesita MCP adicionales"
echo "  3. Crear CLAUDE.md en la raíz con el contexto del proyecto"
echo "  4. Instalar uv si no lo tenés: brew install uv  (necesario para code-review-graph)"
echo "  5. Verificar MCP: claude mcp list"
