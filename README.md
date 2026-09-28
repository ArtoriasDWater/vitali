# Proyecto Hospital (Vitali)

## Proyecto A — Salud: Adherencia y acompañamiento en tratamientos crónicos

Aplicación Flutter orientada a mejorar la adherencia a tratamientos médicos y apoyar a pacientes y cuidadores en el seguimiento de medicación fuera del consultorio. El proyecto se encuadra en la propuesta de salud donde la app permite registrar medicamentos, generar recordatorios y dar visibilidad a un familiar o cuidador sobre si el paciente tomó la dosis o no.

La app actual ya construye la base técnica de este tipo de producto: autenticación, gestión de medicamentos, OCR de recetas y recordatorios con notificaciones. Lo que falta es convertirla en una solución completa de adherencia terapéutica con roles, alertas, métricas y criterio clínico.

**Versión:** `1.0.0+1`  
**SDK Dart:** `^3.10.8`  
**Package:** `proyecto_hospital`  
**Application ID Android:** `com.example.proyecto_hospital`

---

## Visión del producto

Este proyecto busca resolver el problema real de la no-adherencia a tratamientos, especialmente en adultos mayores con polifarmacia, donde:

- el paciente olvida o no toma la medicación según la indicación
- el cuidador no tiene una vista clara del cumplimiento
- las alertas se quedan solo en la intención de recordar, pero no en la confirmación real de la toma
- el sistema de salud no facilita seguimiento fuera del consultorio

La idea central es simple y valiosa: registrar la medicación, recordar la hora, validar si se tomó y alertar si hubo omisiones repetidas.

---

## Estado real del proyecto

### ✅ Ya implementado

| Área | Estado | Evidencia en la app |
|------|--------|---------------------|
| Arquitectura base | Implementada | `main.dart`, `core/`, `features/`, `provider`, `GetIt` |
| Firebase | Configurado | Inicialización con `Firebase.initializeApp` |
| Autenticación | Funcional | login, registro y sesión por Firebase Auth |
| Gestión de medicamentos | Funcional | CRUD con provider, repositorio y pantallas |
| OCR de receta | Funcional | `image_picker` + `google_mlkit_text_recognition` |
| Recordatorios | Funcional | creación, edición, eliminación y marcación de estado |
| Notificaciones locales | Funcional | `flutter_local_notifications` con programación por fecha/hora |
| Tema visual | Implementado | paleta visual para app médica |
| Inyección de dependencias | Implementada | `injectable` + `RegisterModule` |
| Manejo de errores | Implementado | `AppException` y validación de flujo |

### 🔄 En progreso / parcialmente preparado

| Área | Estado | Qué falta |
|------|--------|-----------|
| Paciente + cuidador | Base preparada | aún no hay vínculo explícito, permisos ni reglas por rol |
| Confirmación de toma | Parcial | se puede marcar un recordatorio, pero no se modela claramente la adherencia por día/semana |
| Dashboard de seguimiento | No implementado | falta métricas de cumplimiento y alertas de omisión |
| Roles hospitalarios | No implementado | paciente, cuidador, profesional médico, administrador |
| Seguridad de salud | Necesaria | reglas Firestore por vínculo + minimización de datos |
| Testing | Implementado en base funcional | suite de pruebas para providers, auth, medicamentos, asistentes y caregiver |

### ❌ Aún no implementado para cumplir la propuesta de Proyecto A

- vínculo real entre paciente y cuidador con permisos diferenciados
- confirmación de toma con estado explícito: tomado / omitido / pospuesto
- alertas escalonadas: primera omisión, segunda omisión, repetición sostenida
- reporte semanal de adherencia por medicamento y por paciente
- modo accesible con texto grande, lectura por voz y UX clara para adulto mayor
- flujo clínico con profesionales de salud con vista solo lectura
- chat o asistente médico con guardrails estrictos, sin sugerir dosis ni diagnosticar
- exportación de historial para revisión médica o familiar
- reglas de IA cuidadosas en salud y no uso de profiling automatizado

---

## Testing implementado

Se añadieron pruebas reales para validar la lógica central de la aplicación y dejarla en un estado más confiable:

- validación de creación y actualización de medicamentos
- rechazo de datos inválidos con `AppException`
- marcado de recordatorios como tomados
- flujos de autenticación y estado global del usuario
- providers de medicamentos, cuidadores y chat
- comportamiento inicial del asistente medicinal

Archivos de pruebas:

- [test/medication_and_reminder_usecases_test.dart](test/medication_and_reminder_usecases_test.dart)
- [test/app_core_suite_test.dart](test/app_core_suite_test.dart)

La suite actual cubre la base funcional del proyecto y fue ejecutada correctamente con Flutter. Se sigue recomendando ampliar la cobertura para Firebase, notificaciones y flujos de integración, pero la base de calidad ya está establecida.

> Estado verificado: la suite principal de la app pasó correctamente en ejecución real con `flutter test`.

---

## Qué hace la app hoy según el proyecto A

### 1. Base de autenticación y sesiones
La aplicación ya permite:

- iniciar sesión y registrarse con email/password
- autenticación con Google
- escuchar cambios de sesión globalmente
- mostrar pantalla inicial según si el usuario está autenticado o no

Esto es una base necesaria para separar usuarios tipo paciente y cuidador.

### 2. Registro de medicamentos
La feature de medicamentos ya está diseñada para soportar la gestión de tratamientos:

- listado de medicamentos por usuario
- creación, edición y eliminación
- scan de receta por cámara o galería
- OCR para precargar los datos del medicamento
- flujo de edición manual posterior para validar la información

Esto coincide con la idea del Proyecto A: registrar la medicación y reducir la fricción del ingreso manual.

### 3. Recordatorios y notificaciones
La app ya permite:

- crear recordatorios por medicamento
- editar o borrar recordatorios
- marcar si se tomó la medicación o no
- guardar la lógica en Firestore
- notificar al usuario en la hora indicada

Esta es la pieza más avanzada y útil del estado actual, porque representa el núcleo operativo del seguimiento terapéutico.

### 4. Soporte para medicina digital
La solución ya cuenta con la infraestructura para continuar hacia una app de salud más completa, con:

- almacenamiento de información en Firebase
- capas separadas por dominio y presentación
- notificaciones automatizadas
- integración de visión (OCR) para recetas

---

## Diferencia entre el estado actual y el producto final esperado

### MVP real del Proyecto A

El siguiente nivel funcional que debería alcanzarse es:

1. paciente y cuidador vinculados por una relación explícita
2. cada medicamento asociado a dosis, horario y reglas de recordatorio
3. confirmación de toma por el paciente
4. notificación al cuidador si se omite la dosis
5. registro del cumplimiento semanal
6. pantalla de resumen visual de adherencia

### Funcionalidades importantes que faltan

- alertas escalonadas según número de omisiones consecutivas
- vista del cuidador con detalles del paciente y estado del tratamiento
- accesibilidad para adultos mayores: textos grandes, contrastes, voz y simplicidad
- reporte semanal por medicamento y por paciente
- historial para revisión médica o seguimiento familiar

### Funcionalidades avanzadas previstas

- asistente conversacional para dudas del medicamento con guardrails estrictos
- confirmación por voz
- exportación de historial a PDF o reportes médicos
- soporte para más de un paciente por cuidador

---

## Criterio de IA para este proyecto

El proyecto A tiene una norma importante: la IA solo debe usarse donde aporta valor y no compromete seguridad o salud.

### Sí conviene usar IA en:

- OCR de recetas para reducir esfuerzo al ingresar medicamentos
- resumen o apoyo textual para dudas generales sobre un medicamento
- traducción de textos básicos o apoyo de lectura para accesibilidad

### No conviene usar IA en:

- predecir abandono o riesgo clínico de un paciente a partir de patrones de uso
- sugerir dosis o diagnosticar
- automatizar decisiones médicas sin revisión humana

En el proyecto, la regla recomendada es clara y transparente:

> 3 dosis seguidas omitidas => alerta para el cuidador

Esto es más seguro y mucho más auditable que un “score” de riesgo generado por un modelo.

---

## Stack técnico actual

### Dependencias principales

| Paquete | Uso actual |
|---------|-----------|
| `flutter` | app principal |
| `provider` | manejo de estado global |
| `get_it` + `injectable` | inyección de dependencias |
| `firebase_core` | Firebase inicialización |
| `firebase_auth` | login / sesión |
| `cloud_firestore` | persistencia de medicamentos y recordatorios |
| `firebase_storage` | almacenamiento de imágenes y archivos |
| `google_sign_in` | autenticación con Google |
| `image_picker` | acceso a cámara y galería |
| `google_mlkit_text_recognition` | OCR de recetas |
| `flutter_local_notifications` | recordatorios locales |
| `timezone` | soporte horario para notificaciones |

### Dependencias de desarrollo

- `flutter_lints`
- `injectable_generator`
- `build_runner`
- `mockito`

---

## Estructura real del proyecto

```text
lib/
├── main.dart
├── firebase_options.dart
├── core/
│   ├── di/
│   │   ├── injection.dart
│   │   ├── injection.config.dart
│   │   └── register_module.dart
│   ├── error/
│   │   └── app_exception.dart
│   ├── services/
│   │   └── notification_service.dart
│   └── theme/
│       └── app_theme.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── medications/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── reminders/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── firebase_options.dart
```

---

## Roadmap recomendado

### Fase 1 — consolidar la base de adherencia
- roles paciente/cuidador
- vinculación explícita de personas
- estados de toma y omisión
- alertas simples y transparentes

### Fase 2 — métricas de cumplimiento
- reportes semanales y diarios
- visualización de adherencia por medicamento
- historial de dosis y omisiones

### Fase 3 — experiencia humana y accesible
- texto grande, UX para mayores
- lectura por voz y confirmación por voz
- diseño de notificaciones humanizadas

### Fase 4 — IA con guardrails y seguridad
- OCR validado por humano
- asistente de dudas con restricciones
- nunca sugerir dosis ni diagnosticar

### Fase 5 — preparación para entorno real de salud
- permisos por rol
- seguridad de datos sensibles
- documentación para cumplimiento y validación clínica

---

## Requisitos de ejecución

```bash
cd proyecto_hospital
flutter pub get
flutter run
```

Si se cambia la infraestructura de dependencias o se agregan nuevos providers/servicios:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Análisis del proyecto:

```bash
flutter analyze
```

---

## Observaciones importantes

- La app ya tiene una base sólida para un proyecto de salud real: autenticación, medicamentos, OCR y recordatorios funcionales.
- El siguiente paso crítico es cerrar el flujo de paciente + cuidador y convertir las notificaciones en un sistema real de adherencia terapéutica.
- El proyecto tiene un fuerte valor real en salud digital, pero debe desarrollarse con prudencia, validación humana y criterio de IA.
- Ya se incorporó una suite de pruebas funcionales para auth, medicamentos, cuidadores, chat y recordatorios.
- Aún falta ampliar la cobertura a reglas de horario, alertas, notificaciones programadas y flujos con Firebase para cerrar la confianza técnica del proyecto.

---

## Historial de documentación

Este README se actualiza para reflejar el estado real del proyecto y dejar claro que, aunque la base técnica ya está construida, el proyecto aún necesita cerrar la parte de adherencia, caregiver, métricas y seguridad para llegar a la visión del Proyecto A de salud.
