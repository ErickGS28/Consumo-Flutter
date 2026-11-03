# Evidencias — Recetario UTEZ

**Nombre:**
**Matrícula:**
**Fecha:**
**Dispositivo donde se probó:** (emulador Android, teléfono, Chrome, Windows, macOS…)

## 1. Del JSON a Dart

| JSON | Campo Dart | Tipo | Regla (obligatorio, tolerado, valor por defecto) |
|---|---|---|---|
| id | id | int | obligatorio |
| name | nombre | String | obligatorio |
| cuisine | cocina | String | obligatorio |
| difficulty | dificultad | Dificultad | tolerado → desconocida si no es Easy/Medium/Hard |
| prepTimeMinutes | minutosPreparacion | int | obligatorio |
| cookTimeMinutes | minutosCoccion | int | obligatorio |
| servings | porciones | int | obligatorio |
| rating | calificacion | double | obligatorio (entero o decimal → double) |
| tags | etiquetas | List<String> | opcional, por defecto lista vacía |
| ingredients | ingredientes | List<String> | opcional, por defecto lista vacía |

## 2. Escenarios probados con el servicio real

| Escenario | Cómo lo provoqué | Qué vio la persona | Línea de la bitácora | Captura | Prueba del kit que lo cubre |
|---|---|---|---|---|---|
| Éxito | | | | | |
| Vacío | | | | | |
| Error del servidor | | | | | |
| Sin red | | | | | |
| Tiempo agotado | | | | | |

## 3. Preguntas de reflexión

1. ¿En qué se diferencian el escenario "Error del servidor" y "Sin red" desde el punto de vista de HTTP?
2. ¿Por qué "Vacío" no es un error?
3. La búsqueda de la persona viaja en la query. ¿Por qué tu bitácora no la escribe?
4. Si DummyJSON cambiara `rating` por `score`, ¿qué archivos tendrías que modificar y por qué solo esos?
