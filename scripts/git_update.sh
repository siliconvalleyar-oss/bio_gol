#!/bin/bash

# ============================================
# 🚀 Git Auto-Commit con Timestamp
# Formato: YYYYMMDD:HH:MM + comentario personalizado
# ============================================

# Colores para output más bonito
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================
# 📅 Generar timestamp en formato YYYYMMDD:HH:MM
# ============================================
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
HOUR=$(date +%H)
MINUTE=$(date +%M)

TIMESTAMP="${YEAR}${MONTH}${DAY}:${HOUR}:${MINUTE}"

# ============================================
# 📝 Obtener mensaje del usuario (primer argumento)
# ============================================
if [ -z "$1" ]; then
    echo -e "${YELLOW}⚠️  Advertencia: No proporcionaste ningún comentario${NC}"
    echo -e "Uso: $0 \"tu comentario aquí\""
    echo -e "Ejemplo: $0 \"Fix bug en el login\""
    exit 1
fi

COMMENT="$1"
FULL_MESSAGE="${TIMESTAMP} ${COMMENT}"

# ============================================
# 🔄 Mostrar información antes de continuar
# ============================================
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${GREEN}📦 Git Auto-Commit${NC}"
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${YELLOW}📅 Timestamp:${NC} ${TIMESTAMP}"
echo -e "${YELLOW}💬 Comentario:${NC} ${COMMENT}"
echo -e "${YELLOW}✅ Mensaje completo:${NC} ${FULL_MESSAGE}"
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo ""

# ============================================
# 📁 Verificar si estamos en un repositorio git
# ============================================
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: No estás en un repositorio Git${NC}"
    exit 1
fi

# ============================================
# 🔍 Verificar cambios antes de continuar
# ============================================
if git diff --quiet && git diff --cached --quiet; then
    echo -e "${YELLOW}⚠️  No hay cambios para commitear${NC}"
    exit 0
fi

# ============================================
# 📊 Mostrar qué archivos van a ser commitados
# ============================================
echo -e "${BLUE}📝 Archivos a commitear:${NC}"
git status --short
echo ""

# ============================================
# 🚀 Ejecutar comandos git
# ============================================

# 1. Agregar todos los cambios
echo -e "${GREEN}➡️  git add .${NC}"
git add .
echo -e "${GREEN}✅ Archivos agregados${NC}"
echo ""

# 2. Hacer commit con el formato personalizado
echo -e "${GREEN}➡️  git commit -m \"${FULL_MESSAGE}\"${NC}"
git commit -m "$FULL_MESSAGE"
echo -e "${GREEN}✅ Commit creado${NC}"
echo ""

# 3. Pull con rebase
echo -e "${GREEN}➡️  git pull --rebase${NC}"
if git pull --rebase; then
    echo -e "${GREEN}✅ Pull completado${NC}"
else
    echo -e "${RED}❌ Error en pull --rebase. Resuelve los conflictos manualmente${NC}"
    exit 1
fi
echo ""

# 4. Push a remote
echo -e "${GREEN}➡️  git push${NC}"
if git push; then
    echo -e "${GREEN}✅ Push completado${NC}"
else
    echo -e "${RED}❌ Error en push. Verifica tu conexión o permisos${NC}"
    exit 1
fi

# ============================================
# 🎉 Resumen final
# ============================================
echo ""
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${GREEN}🎉 ¡TODO COMPLETADO EXITOSAMENTE! 🎉${NC}"
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${YELLOW}📝 Commit:${NC} ${FULL_MESSAGE}"
echo -e "${YELLOW}🕐 Hora:${NC} $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${BLUE}════════════════════════════════════════════${NC}"

