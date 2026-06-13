# Historial de Solicitudes — 11 Jun 2026

## Solicitud 1
> "en la lista de usuarios , el puntaje queda en cero . como que no es el mismo que el del jugador que jugo y eso que es la misma persona . si presionas jugar si aparece el puntaje , pero esta en ecero la muestra . sin embargo en el ranking si esta el puntaje . rehacer la trivia multitarea volverla como la inicial . leer skill de esa etapa o item . por que no responde esta la pantalla en gris . el test de reaccion , los botones siguen abajo muy abajo .deben quedar mas arriba a la altura del 25 desde abajo a arriba eje Y . no lo modifico ."

**Problemas reportados:**
- Lista de usuarios muestra puntos en cero (usa `u.puntos` en vez de `u.puntosTotales`)
- Pantalla de trivia no responde (gris) — timer arranca antes de cargar configuración
- Botones de test de reacción muy abajo

**Soluciones aplicadas:**
- `usuarios_screen.dart:466`: `u.puntos` → `u.puntosTotales`
- `trivia_screen.dart`: moví `_iniciarTimer()` dentro de `_cargarInicio()` async para que arranque después de leer SharedPreferences
- `reaccion_screen.dart`: moví `Row(buttons)` antes del `Spacer(flex: 1)` para que queden a ~75% desde arriba

---

## Solicitud 2
> "la trivia demo , sin embargo funciona . solo los botones de la trivia estan muy abajo . casi no se ven . subirlo 20 porciento mas de abajo hacua arriba eje Y"

**Problema:** Botones Verdadero/Falso en la trivia están al fondo, apenas visibles.

**Solución:** En `_buildQuestionCard`, cambié el `Expanded` del texto a `flex: 4` y agregué un `Expanded(flex: 1)` debajo de los botones para empujarlos al 80% desde arriba (20% desde abajo). El feedback de correcto/incorrecto va dentro de ese `Expanded`.

---

## Solicitud 3
> "la respuesta de los sonidos de las trivias mundialista demo son los mismos sonidos de frecuancias . deben ser los texto s que le habia pasado y no hizo."

**Problema:** Los archivos MP3 de feedback (gol, golazo, etc.) eran tonos/silbidos genéricos, no voces diciendo las palabras.

**Solución:** Regeneré los 12 archivos MP3 con `gtts` (Google Text-to-Speech) en español:
- `gol.mp3` — "¡Gol!"
- `golazo.mp3` — "¡Golazo!"
- `perfecto.mp3` — "Perfecto"
- `vamosbien.mp3` — "Vamos bien"
- `genio.mp3` — "Genio"
- `crack.mp3` — "Crack"
- `larompiste.mp3` — "¡La rompiste!"
- `afuera.mp3` — "Afuera"
- `miratecomo.mp3` — "Mírate cómo"
- `mejora.mp3` — "Mejora"
- `debesestudiar.mp3` — "Debes estudiar"
- `entrenaconlibros.mp3` — "Entrena con libros"

---

## Solicitud 4
> "escribir un archivo nuevo llamado "prompt.md" poner todas las solicitudes que hice hoy . guardarlas ahi . como un historial en orden de lo que solicite .pedido por pedido"

**Acción:** Este archivo.

---

## Solicitud 5
> "la opcion 'trivia mundialera' sigue sin funcionar , solo aparece una pantalla en gris . comparar con la version del opcion  demo de muestra , esa trivia demo anda. solo convertirla con la solicitud de anterior . 16 preguntas , y que sea con audio  , verdadero o falso el audio . segun corrponda."

**Problema:** La trivia no-demo (trivia mundialera) muestra pantalla gris. La demo funciona bien.

**Causa raíz:** `_preguntas` estaba declarado como `late final`. En el path no-demo se asignaba dos veces:
1. `_preguntas = List.from(PreguntaTrivia.lista)`
2. `_preguntas = _preguntas.sublist(0, 16)` ← ¡crashea! `late final` no permite reasignación

El path demo solo asigna una vez (no hace sublist), por eso funcionaba.

**Solución:** Cambié `late final` → `late` en la declaración de `_preguntas` (trivia_screen.dart:38).
