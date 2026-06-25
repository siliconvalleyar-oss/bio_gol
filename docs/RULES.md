# RULES

## Regla de Oro ⭐

1. **No borrar archivos** - Si un archivo debe eliminarse, **no se borra**. Se mueve a la carpeta `olds/` en la raíz del proyecto.
2. **No desinstalar la app del móvil** - Al subir al móvil usar `adb install -r build/app/outputs/flutter-apk/app-debug.apk` para **reemplazar** la app sin desinstalarla. No usar `flutter install` porque desinstala primero y obliga a esperar y autorizar permisos nuevamente.

## Reglas de desarrollo

1. **No borrar, reemplazar** - Todo cambio debe reemplazar código existente, no eliminar funcionalidad sin reemplazo equivalente.
2. **Versionado** - Cada push debe llevar un tag de versión (formato vX.Y.Z). El tag siempre debe coincidir con el contenido del archivo `VERSION` en la raíz del proyecto.
3. **VERSION** - Antes de cada commit/push, actualizar `VERSION` con el mismo número que el tag (sin la `v`). Ej: tag `v1.0.3` → VERSION `1.0.3`.
4. **Documentación** - Mantener docs/ actualizada con cada cambio relevante.
5. **Compilación móvil** - Compilar y subir al móvil para verificar cambios.
6. **Commit descriptivo** - Mensajes claros en cada commit.
