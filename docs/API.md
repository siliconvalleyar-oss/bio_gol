# API

## Almacenamiento local

La app usa `SharedPreferences` para persistencia. No hay backend remoto.

### Claves de SharedPreferences

| Clave | Tipo | Descripción |
|-------|------|-------------|
| `usuarios` | String (JSON) | Lista de usuarios registrados |
| `notas` | String | Notas del administrador |
| `usuarioIdx` | int | Índice del usuario activo |
| `paletaId` | String | Paleta de colores seleccionada |
| `fontSize` | double | Tamaño de fuente global |
| `colorDuracionMs` | double | Duración de muestra en test de colores |
| `paisDuracionMs` | double | Duración de muestra en test de países |
| `triviaTimer` | int | Tiempo límite de trivia |
| `audioMap` | String (JSON) | Mapa de nombres de archivos de audio |

### Modelo Usuario

```dart
Usuario {
  id, nombre, edad, alias, pais, email, telefono,
  puntos, aciertos, racha, rachaMax,
  reaccionPromedio, colorTestPuntos, sonidoTestPuntos, paisTestPuntos,
  fecha
}
```

## Puntajes

- **Test de Reacción:** Promedio de tiempo en ms (menor = mejor)
- **Test de Colores:** Puntos por tiempo restante (más rápido = más puntos)
- **Test de Países:** Puntos por tiempo restante (más rápido = más puntos)
- **Test de Sonidos:** 10 pts a 100ms, -1 pts cada 100ms, min 1 pt
- **Trivia:** Puntos por respuestas correctas consecutivas (racha)
