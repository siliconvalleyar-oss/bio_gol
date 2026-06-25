# Arquitectura

## Stack tecnológico

- **Framework:** Flutter (SDK ^3.12.1)
- **Lenguaje:** Dart
- **Almacenamiento local:** SharedPreferences
- **Audio:** audioplayers ^6.0.0
- **QR:** qr_flutter ^4.1.0
- **Compartir:** share_plus ^10.0.0

## Estructura de directorios

```
lib/
├── main.dart                # Punto de entrada
├── app_theme.dart           # Tema, colores, estilos
├── home_screen.dart         # Pantalla principal con navegación
├── model/
│   └── data.dart            # Modelos de datos (Usuario, PaisInfo, etc.)
├── screens/
│   ├── admin_screen.dart    # Panel de administración
│   ├── circuito_screen.dart # Circuito sensorial
│   ├── color_test_screen.dart # Test de colores
│   ├── diploma_screen.dart  # Diploma / certificado
│   ├── modelo_screen.dart   # Modelo E-R-P-R-E
│   ├── paises_test_screen.dart # Test de banderas
│   ├── ranking_screen.dart  # Ranking / leaderboard
│   ├── reaccion_screen.dart # Test de tiempo de reacción
│   ├── situaciones_screen.dart # Situaciones de fútbol
│   ├── sonido_test_screen.dart # Test de sonidos
│   ├── trivia_screen.dart   # Trivia verdadero/falso
│   └── usuarios_screen.dart # Registro de usuarios
└── services/
    └── audio_service.dart   # Servicio de reproducción de audio
```

## Flujo de datos

1. Usuario se registra → `Usuario` guardado en SharedPreferences como JSON
2. Cada test actualiza los puntos del `Usuario` activo
3. `AppState` maneja el estado global de la sesión
4. Los resultados persisten localmente

## Tests disponibles

- **Test de Reacción** - 6 oportunidades, mide tiempo de respuesta
- **Test de Colores** - Identificar color mostrado brevemente
- **Test de Países** - Identificar bandera mostrada brevemente
- **Test de Sonidos** - Identificar tono (grave/media/aguda)
- **Trivia** - Preguntas verdadero/falso sobre sistema nervioso
- **Circuito Sensorial** - 5 estaciones interactivas
- **Situaciones** - 20 tarjetas con casos de fútbol
