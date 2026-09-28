# Ideas de proyecto final (mobile)

Documento con dos bloques de propuestas:

1. **Ideas de portafolio** — enfoques por sector con integración de IA
2. **Proyectos reales** — propuestas detalladas con arquitectura, seguridad y criterio de IA

---

## Índice

### Ideas de portafolio

| # | Enfoque | Nombre |
|---|---------|--------|
| 1 | EdTech | Plataforma de Gestión de Tutorías y Retos |
| 2 | AgTech | Asistente de Bio-fertilizantes para Caficultura |
| 3 | Cívico / Social | Red de Emprendimiento y Liderazgo Juvenil |
| 4 | Health & Fitness | Optimizador de Hipertrofia y Nutrición |

### Proyectos reales

| # | Sector | Nombre |
|---|--------|--------|
| A | Salud | Adherencia y acompañamiento en tratamientos crónicos |
| B | Movilidad y seguridad | Acompañamiento en trayectos urbanos |
| C | Educación / bienestar | Prevención de deserción universitaria |
| D | Comercio | Digitalización asistida por IA para microemprendedores |

---

# Parte I — Ideas de portafolio

Cuatro enfoques posibles para el portafolio. Cada uno incluye problema real, funcionalidades, integración de IA y valor técnico.

---

## 1. EdTech — Plataforma de Gestión de Tutorías y Retos

Aplicación orientada a instructores que enseñan a programar a diferentes públicos (desde niños hasta adultos).

### Problema

Gestionar el progreso de múltiples alumnos con niveles distintos y crear material didáctico consume mucho tiempo.

### Funcionalidades

- Perfiles separados para tutor y estudiante
- Sistema de seguimiento de módulos de aprendizaje
- **Integración IA:** generador de retos de código. El tutor selecciona el tema (ej. "Ciclos en Java" o "Widgets en Flutter") y el nivel (niño, joven, adulto); la IA genera un ejercicio a medida con su respectiva solución

### Valor para el portafolio

Demuestra dominio en roles de usuario, estructuras de datos relacionales complejas y uso práctico de la API de Gemini u OpenAI (prompt engineering).

---

## 2. AgTech — Asistente de Bio-fertilizantes para Caficultura

Herramienta técnica para el sector agrícola, enfocada en la sostenibilidad y el manejo de cultivos de café.

### Problema

La preparación de abonos orgánicos requiere proporciones precisas y un seguimiento de tiempos y temperaturas que muchos agricultores llevan en papel.

### Funcionalidades

- Calculadora de proporciones para formulaciones específicas (como el abono Bocashi)
- Cronograma de volteo, control de temperatura y fermentación con notificaciones push
- **Integración IA:** bot de diagnóstico. El usuario describe el estado de su mezcla o reporta una temperatura anómala; la IA sugiere acciones correctivas inmediatas

### Valor para el portafolio

Impacto territorial real. A nivel técnico: almacenamiento local (ideal sin internet en la finca), sincronización en la nube con Firestore y notificaciones programadas.

---

## 3. Cívico / Social — Red de Emprendimiento y Liderazgo Juvenil

Red para conectar iniciativas, propuestas y proyectos de jóvenes emprendedores en una región específica (por ejemplo, Antioquia).

### Problema

Las plataformas departamentales de juventud y las mesas subregionales a menudo no tienen un medio centralizado para que los jóvenes expongan sus proyectos, busquen colaboradores o reciban mentoría.

### Funcionalidades

- Feed de proyectos y propuestas de desarrollo territorial
- Sistema de "match" entre proyectos y perfiles técnicos o voluntarios
- **Integración IA:** asistente de pitch. El usuario ingresa la idea básica de su emprendimiento; la IA ayuda a estructurar un discurso persuasivo o a mejorar la redacción de la propuesta para presentarla a entidades

### Valor para el portafolio

Muestra capacidad para construir apps sociales interactivas, manejar datos en tiempo real (sockets o streams en Firebase) y aplicar Clean Architecture en módulos con gran volumen de datos.

---

## 4. Health & Fitness — Optimizador de Hipertrofia y Nutrición

Aplicación técnica para personas enfocadas en el entrenamiento de fuerza y la ganancia muscular.

### Problema

Las apps de fitness suelen ser muy genéricas y no ajustan la suplementación según el progreso real del entrenamiento de hipertrofia.

### Funcionalidades

- Registro de cargas, volumen de entrenamiento y rutinas semanales
- Calculadora de macros diarios, con énfasis en proteínas y suplementos
- **Integración IA:** análisis del estancamiento. Si el usuario no sube sus cargas en 3 semanas, la IA analiza los datos registrados y sugiere ajustes en nutrición (tiempos de proteína) o en volumen de entrenamiento (descargas)

### Valor para el portafolio

Requiere gráficos estadísticos complejos, animaciones fluidas (ideal para destacar UI/UX en Flutter) y lógica matemática en el backend para el cálculo calórico.

---

# Parte II — Proyectos reales

Propuestas con mayor detalle técnico, criterio de uso de IA y consideraciones de arquitectura, seguridad y escalabilidad.

---

## Proyecto A — Salud: Adherencia y acompañamiento en tratamientos crónicos

### Problema

La no-adherencia a tratamientos médicos (pacientes que no toman su medicación como fue prescrita) es una de las principales causas de reingresos hospitalarios evitables, especialmente en adultos mayores con varios medicamentos simultáneos (polifarmacia). Los cuidadores/familiares no tienen visibilidad real de si el paciente tomó o no su medicación.

### Contexto

Ocurre en el cuidado ambulatorio/post-hospitalario, en cualquier sistema de salud de la región. La carga de enfermedades crónicas (hipertensión, diabetes) va en aumento y el sistema de salud prescribe pero rara vez monitorea adherencia fuera del consultorio.

### Usuarios

- Paciente (a menudo adulto mayor)
- Cuidador/familiar vinculado
- A futuro: profesional de salud con vista de solo lectura

### Solución

App donde se registra la medicación (agilizado con OCR de la receta), se generan recordatorios, el paciente confirma cada toma, y el cuidador recibe alertas si hay dosis omitidas.

### Funcionalidades

| Nivel | Detalle |
|-------|---------|
| **MVP** | Registro manual de medicamentos, recordatorios push, confirmación de toma, vínculo con un cuidador, auth con Firebase |
| **Importantes** | Escaneo de receta con OCR para autocompletar, reporte semanal de adherencia, alertas escalonadas al cuidador, modo accesible (texto grande, TTS) |
| **Avanzadas** | Asistente conversacional para dudas generales del medicamento (con guardrails fuertes), confirmación de toma por voz |
| **Futuras** | Export a PDF para consulta médica, un cuidador con múltiples pacientes |

### Inteligencia artificial (con criterio)

**OCR de recetas (ML Kit, on-device)**
- Resuelve la fricción de digitar manualmente
- Corre en el dispositivo → gratis y privado (la imagen no sale del teléfono)
- Riesgo real: una dosis mal leída (ej. "5mg" → "6mg") puede ser peligroso; nunca se autoaplica, siempre requiere confirmación humana antes de guardar

**Asistente conversacional**
- Útil para dudas frecuentes, pero es la función de más alto riesgo del proyecto
- Modelo vía backend intermedio (la key jamás en el cliente)
- System prompt que prohíbe explícitamente sugerir dosis o diagnosticar
- Costo por token, bajo si se limita el uso mensual por usuario
- Privacidad: enviar solo el nombre del medicamento y la pregunta, nunca historial clínico completo
- Las alucinaciones en salud son especialmente peligrosas; el disclaimer "no reemplaza a tu médico" debe ser permanente y visible

**Dónde NO usar IA**
- No usar un modelo para "predecir" abandono de tratamiento a partir de patrones de uso — es profiling automatizado sobre población vulnerable sin el rigor clínico necesario
- Mejor una regla simple y transparente: "3 dosis seguidas omitidas → alerta"

### Stack y arquitectura

| Área | Detalle |
|------|---------|
| **Tecnología** | Flutter + Provider, Firebase completo, ML Kit OCR, flutter_tts/speech_to_text, Cloud Functions como intermediario de IA |
| **Arquitectura** | Clean Architecture por features (`medications/`, `reminders/`, `caregiver/`, `chat/`), repository pattern sobre Firestore, casos de uso explícitos |
| **Seguridad** | Datos de salud tratados con máximo cuidado aunque no sea HIPAA-certificado: Rules estrictas por vínculo paciente-cuidador, nunca loggear info médica en crash reports, secure storage de tokens |
| **Testing** | Lógica de horarios/recordatorios (zonas horarias, dosis cada 8h), reglas de alerta al cuidador, mocks del OCR y del backend de IA |
| **DevOps** | CD con aprobación manual antes de producción (no automático, por ser salud), Fastlane + testers cerrados primero |
| **Escalabilidad** | Firestore es suficiente para portafolio; documentar cómo migraría a un backend dedicado si se necesitara compliance real (HIPAA / tipo Ley 1581 en Colombia) |

### Potencial real

Portafolio muy fuerte; con validación clínica podría interesar a IPS/EPS o cuidado domiciliario privado.

---

## Proyecto B — Movilidad y seguridad: Acompañamiento en trayectos urbanos

### Problema

Muchas personas —mujeres, trabajadores nocturnos, repartidores— se sienten inseguras en trayectos a pie o en transporte informal, sobre todo de noche, y no tienen una forma confiable de compartir su trayecto en vivo ni de alertar rápido en caso de peligro (más allá de mandar ubicación manual por WhatsApp).

### Contexto

Muy presente en ciudades como Bogotá: trayectos nocturnos, transporte informal, zonas con reportes de inseguridad.

### Usuarios

- Persona en tránsito
- Contacto de confianza que monitorea
- A futuro: operador de seguridad institucional (campus, empresa de domicilios)

### Solución

"Trayecto acompañado": comparte ubicación en vivo con contactos durante el viaje, detecta desvíos fuertes de ruta o paradas prolongadas y pregunta si todo está bien, botón de pánico táctil o por voz.

### Funcionalidades

| Nivel | Detalle |
|-------|---------|
| **MVP** | Contactos de confianza, iniciar/finalizar trayecto con ubicación en vivo, botón de pánico manual |
| **Importantes** | Detección de desvío de ruta/parada prolongada con confirmación, mapa comunitario de reportes de incidentes (moderado), historial de trayectos |
| **Avanzadas** | Activación de alerta por comando de voz |
| **Futuras** | Modo empresa para flotas de repartidores |

### Inteligencia artificial (con criterio)

**Activación por voz**
- Útil; reconocimiento de palabra clave preferiblemente local
- Nunca audio continuo enviado a servidores externos

**Dónde NO usar IA (esto es lo importante aquí)**
- No usar un modelo para "puntuar" el riesgo de una zona geográfica a partir de reportes de usuarios — reproduce sesgos existentes (estigmatiza zonas de bajos ingresos) y da una falsa sensación de certeza
- Mejor mostrar reportes crudos con fecha, sin score algorítmico
- Tampoco hace falta IA para detectar desvíos de ruta: es geometría simple (distancia a la ruta planeada, tiempo detenido) — meter un modelo ahí sería complejidad sin beneficio

> Este proyecto usa IA de forma deliberadamente acotada — es un buen caso para demostrar criterio, no solo capacidad técnica.

### Stack y arquitectura

| Área | Detalle |
|------|---------|
| **Tecnología** | Flutter, geolocator/google_maps_flutter, Firebase Realtime (Firestore), speech_to_text, Bloc/Cubit (justificado por el manejo de una máquina de estados del trayecto) |
| **Arquitectura** | Motor de reglas de desvío aislado en la capa de dominio, testeable sin depender de Flutter ni Firebase |
| **Seguridad** | La ubicación en vivo es dato crítico — acceso de contactos solo durante la ventana activa del trayecto (no indefinido), borrado automático del historial tras N días, consentimiento explícito de permisos |
| **Testing** | Motor de geofencing (GPS impreciso, túneles), flujo de pánico, expiración de acceso a ubicación |
| **DevOps** | Pruebas de ubicación en background requieren dispositivo real, no solo CI; Google Play es estricto con apps de ubicación — hay checklist de políticas a cumplir |
| **Escalabilidad** | Firestore realtime funciona a escala piloto; a escala ciudad se evaluaría WebSockets dedicado por costo de lecturas |

### Potencial real

Alto valor social; podría ser producto para universidades o empresas de domicilios (seguridad de empleados).

> **Nota honesta:** la geolocalización en background no está en el temario explícito del programa — es la propuesta técnicamente más atractiva pero también la que exige más autoaprendizaje fuera de lo enseñado.

---

## Proyecto C — Educación / bienestar: Prevención de deserción universitaria

### Problema

Un porcentaje alto de estudiantes de primer año abandona la universidad, muchas veces no solo por razones académicas sino por aislamiento y desconocimiento de los recursos de apoyo (tutorías, bienestar) que sí existen pero llegan tarde o nunca.

### Contexto

Las instituciones tienen áreas de bienestar, pero el descubrimiento es pasivo y el seguimiento manual (encuestas esporádicas, hojas de cálculo).

### Usuarios

- Estudiante de primer año
- Tutor/consejero académico
- Coordinador de bienestar (vista agregada)

### Solución

Check-in semanal breve, directorio de recursos filtrable, match con tutor par, y alertas tempranas basadas en reglas simples y transparentes (no un "diagnóstico" de IA).

### Funcionalidades

| Nivel | Detalle |
|-------|---------|
| **MVP** | Registro institucional, check-in semanal, directorio de recursos |
| **Importantes** | Match con tutor/consejero, alerta al consejero por patrón sostenido y explícito (el estudiante sabe que existe esta regla) |
| **Avanzadas** | Resumen asistido por IA de "temas recurrentes" a nivel agregado y anónimo para el consejero |
| **Futuras** | Integración con el sistema académico (requeriría convenio institucional real) |

### Inteligencia artificial (con criterio)

**Dónde NO usar IA**
- No usar IA para predecir quién va a desertar a partir de las respuestas del check-in de forma automática y opaca — es una decisión de alto impacto sobre una persona que no debe delegarse a un modelo de caja negra, menos con el dataset pequeño de un proyecto de portafolio
- Mejor: reglas explícitas y auditables por el propio estudiante

**Dónde SÍ usar IA**
- LLM para resumir texto libre de check-ins agregados ("temas recurrentes esta semana: estrés por exámenes...") sin señalar individuos
- Anonimizar antes de enviar al modelo, agregar mínimo N respuestas antes de resumir
- Riesgo de alucinación: mitigar mostrando fragmentos anónimos de ejemplo junto al resumen para validación humana
- Traducción de recursos: bajo riesgo, buen valor de inclusión para estudiantes internacionales

### Stack y arquitectura

| Área | Detalle |
|------|---------|
| **Tecnología** | Flutter + Provider, Firebase (Auth con custom claims por rol, Firestore, Cloud Functions para el resumen) |
| **Arquitectura** | Separación estricta entre vista estudiante y vista consejero vía Rules + roles |
| **Seguridad** | Datos emocionales son extremadamente sensibles — minimización de datos, el estudiante debe ver exactamente qué comparte y poder borrar su historial |
| **Testing** | Reglas de alerta deterministas, permisos por rol |
| **DevOps** | Estándar; el despliegue real (no solo portafolio) requeriría acuerdo de tratamiento de datos con la universidad — vale documentarlo aunque no se implemente |
| **Escalabilidad** | Buena por institución; multi-institución requeriría particionamiento por tenant |

### Potencial real

Buen ángulo ético para la defensa, pero de los cuatro es el de menor diferenciación técnica (menos hardware/sensores, menos offline, IA más acotada) y menor potencial comercial (nicho institucional).

---

## Proyecto D — Comercio: Digitalización asistida por IA para microemprendedores informales

### Problema

Microemprendedores y vendedores informales (artesanos, negocios de barrio, emprendimientos caseros) pierden ventas porque no tienen tiempo ni conocimiento para armar catálogos atractivos, no llevan registro claro de inventario, y no saben si su negocio realmente es rentable.

### Contexto

Economía informal masiva en Latinoamérica: se vende por WhatsApp/Instagram con fotos improvisadas, sin control de costos, con conectividad intermitente.

### Alcance (importante)

Esto **no** es una tienda online ni un CRUD de productos disfrazado. El foco es un "asistente de trastienda" — el emprendedor sigue vendiendo por sus canales actuales; la app no construye un marketplace.

### Usuarios

- Microemprendedor/a (sin formación técnica)

### Solución

Fotografía un producto → un modelo de visión sugiere título, descripción y precio de referencia (siempre editable); la app lleva inventario y calcula margen; genera un catálogo compartible en PDF; funciona offline-first.

### Funcionalidades

| Nivel | Detalle |
|-------|---------|
| **MVP** | Alta manual de producto, inventario, registro de ventas, funcionamiento offline con sincronización posterior |
| **Importantes** | Sugerencia por IA de título/descripción/precio a partir de foto, generación de catálogo PDF, reporte de rentabilidad mensual |
| **Avanzadas** | Alerta de bajo inventario, traducción del catálogo |
| **Futuras** | Pasarela de pago simple, multi-usuario |

### Inteligencia artificial (con criterio)

**Sugerencia de título/descripción/precio (visión multimodal, Gemini/GPT)**
- Resuelve una barrera real de tiempo/habilidad
- Vía backend intermedio, nunca la key en el cliente
- Costo por imagen procesada — limitar sugerencias gratuitas mensuales dado que es un público sensible al precio
- Privacidad: revisar política del proveedor sobre uso de fotos para entrenamiento
- Riesgo/limitación clave: el precio sugerido puede no calibrar bien al mercado local, por eso nunca se autoaplica, y el prompt debe limitarse a describir solo lo visualmente evidente (evitar afirmar "100% algodón" si no es verificable)

**Dónde NO usar IA**
- Cálculo de margen/rentabilidad: es aritmética simple, no necesita IA — meterla sería complejidad injustificada

### Stack y arquitectura

| Área | Detalle |
|------|---------|
| **Tecnología** | Flutter + Provider, Firebase con persistencia offline de Firestore, Storage, Cloud Functions, paquete pdf |
| **Arquitectura** | Capa de datos con cola de sincronización offline-first, resolución de conflictos documentada como decisión consciente ("último cambio gana") |
| **Seguridad** | Datos financieros del negocio (costos, márgenes) — el catálogo exportado debe excluir campos internos |
| **Testing** | Lógica de inventario (stock no negativo, margen), cola de sincronización offline, mocks del servicio de visión |
| **DevOps** | El comportamiento offline es difícil de probar en CI, documentar como prueba manual |
| **Escalabilidad** | Offline-first es una elección fuerte por el contexto real de conectividad; a futuro SQLite local + sync propio si crece el volumen |

### Potencial real

El de mayor atractivo de mercado masivo (inclusión financiera, ONGs de emprendimiento, programas de formalización) — pero también el que corre más riesgo de "sentirse como CRUD" si se pierde de vista el enfoque en IA + realidad offline.
