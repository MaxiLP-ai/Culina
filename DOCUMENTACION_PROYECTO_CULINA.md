# Culina — Documentación Técnica y Funcional del Proyecto

**Asignatura:** Desarrollo de Aplicaciones Móviles  
**Institución:** Universidad Técnica Federico Santa María (UTFSM)  
**Equipo de Desarrollo:**  
- Matías Tapia  
- Maximiliano Lopez  
- José-Luis Hidalgo  
**Repositorio Oficial:** [github.com/MaxiLP-ai/Culina](https://github.com/MaxiLP-ai/Culina.git)  
**Versión:** 2.0 (Versión Mejorada con Valor Agregado)  

---

## 1. Resumen Ejecutivo y Propósito de la Aplicación

**Culina** es una aplicación móvil diseñada para entusiastas de la cocina casera y artesanal. A diferencia de los recetarios genéricos sobrecargados de publicidad o listas estáticas poco prácticas, Culina pone el foco en la calidez del diseño editorial clásico (estilo papel pergamino y tipografía artesanal) combinado con herramientas funcionales interactivas para el momento real en que el usuario está cocinando frente al fuego.

La aplicación permite explorar recetas clasificadas por categorías, ajustar dinámicamente las cantidades de ingredientes según la cantidad de comensales, seguir un modo de cocina guiada paso a paso con temporizador incorporado, gestionar recetas favoritas y crear o editar recetas propias con persistencia de datos.

---

## 2. Arquitectura de Software y Estándares de Código

Para garantizar un código mantenible, escalable y con separación clara de responsabilidades, el proyecto implementa los principios de **Clean Architecture** junto con el patrón de diseño de estado **Provider** (MVVM):

```
lib/
├── data/
│   ├── models/            # Serialización y deserialización de datos (RecipeModel, IngredientModel)
│   ├── repositories/      # Implementación concreta de repositorios (RecipeRepositoryImpl)
│   └── services/          # Fuentes de datos locales y simulación de backend (RecipeLocalService, AuthService)
├── domain/
│   ├── entities/          # Entidades puras del negocio sin dependencias externas (Recipe, Ingredient, UserProfile)
│   └── repositories/      # Contratos e interfaces abstractas (RecipeRepository)
├── presentation/
│   ├── providers/         # Gestores de estado reactivo (RecipeProvider, UserProvider, ThemeProvider)
│   ├── screens/           # Pantallas de la aplicación (Home, Explore, Detail, CookingMode, Create, Profile, etc.)
│   ├── theme/             # Sistema de diseño, paleta cromática rústica y temas Claro/Oscuro
│   └── widgets/           # Componentes modulares reutilizables (CulinaFoodGraphic, CategoryChip, etc.)
└── main.dart              # Punto de entrada, configuración de proveedores y temas globales
```

### Flujo de Trabajo en Git y Buenas Prácticas
* **Rama `main`**: Contiene únicamente código estable y listo para entrega.
* **Rama `develop`**: Rama base de integración donde convergen los desarrollos y mejoras.
* **Ramas de funcionalidad (`feature/*`)**: Ramas de trabajo individuales para cada componente o ajuste.
* **Pull Requests**: Cada cambio se integra mediante PR con plantilla de revisión de código y validación de análisis estático (`flutter analyze`) y suite de pruebas (`flutter test`).

---

## 3. Desglose de Funcionalidades del Sistema

### 3.1. Autenticación y Perfil de Usuario
* **Inicio de Sesión**: Validación de credenciales para usuarios registrados e invitados.
* **Ficha de Perfil**: Visualización de avatar personalizado con iniciales, datos del usuario, membresía y tags de intereses culinarios.
* **Edición de Biografía**: Modal interactivo para actualizar la descripción del cocinero en tiempo real.
* **Estadísticas de Actividad**: Conteo dinámico de recetas publicadas por el usuario, total de recetas guardadas y categoría preferida según el historial.

### 3.2. Pantalla Principal (Home)
* **Saludo y Cabecera Dinámica**: Mensaje contextual según el usuario autenticado.
* **Receta Destacada del Día**: Tarjeta con ilustración vectorial artesanal, etiquetas de tiempo, dificultad y acceso rápido a detalles.
* **Selector Rápido de Categorías**: Filtro inmediato por pastas, desayunos, almuerzos, ensaladas o recetas rápidas.
* **Carrusel de Preparaciones Rápidas**: Sección curada de platos listos en 25 minutos o menos.

### 3.3. Explorador y Búsqueda Avanzada
* **Buscador en Tiempo Real**: Búsqueda textual por título de receta, descripción, categoría o nombre de ingredientes específicos.
* **Filtros Combinados**: Modal para filtrar por nivel de dificultad (Fácil, Media, Difícil) y tiempo máximo de cocción (< 15 min, < 30 min, < 45 min).
* **Estados Vacíos**: Retroalimentación visual amigable con ilustración y opción de limpiar filtros cuando no hay coincidencias.

### 3.4. Detalle de Receta y Escalador de Porciones
* **Ficha Técnica**: Tiempos desglosados (preparación, cocción y tiempo total), dificultad y autor.
* **Calculadora de Porciones en Vivo**: Control de incremento y decremento (+ / -) que recalcula matemáticamente al instante las cantidades de cada ingrediente (gramos, mililitros, unidades), evitando que el usuario deba hacer conversiones manuales.
* **Checklist de Ingredientes**: Casillas interactivas para tachar los ingredientes a medida que se preparan sobre la mesada.

### 3.5. Creación y Edición de Recetas (CRUD Completo)
* **Formulario Validado**: Título, categoría, dificultad, autor, tiempos de preparación y cocción, y selección de icono/paleta culinaria.
* **Gestión Dinámica de Ingredientes**: Agregar o quitar ingredientes con sus respectivas cantidades base y unidades.
* **Constructor de Pasos**: Agregar, editar y remover pasos numerados secuenciales.
* **Edición y Eliminación**: Las recetas creadas por el usuario pueden modificarse o eliminarse desde su perfil o pantalla de detalle con diálogo de confirmación.

---

## 4. Matriz Comparativa: Prototipo Inicial (V1) vs Versión Mejorada (V2)

El profesor de la asignatura autorizó optimizar y enriquecer el diseño visual del prototipo de Figma original, manteniendo intacto el 100% de la funcionalidad base e incorporando "pluses" de alto valor técnico y de experiencia de usuario.

A continuación se detalla la justificación técnica de cada decisión adoptada:

| Área o Pantalla | Versión 1 (Prototipo Inicial Figma) | Versión 2 (Implementación Final Culina) | ¿Qué y por qué lo hicimos? (Justificación Técnica y UX) |
|---|---|---|---|
| **Experiencia de Cocina** | La vista de detalle era un scroll largo estático donde los pasos se leían en texto pequeño. | **Modo Cocina Guiada Paso a Paso (`CookingModeScreen`)**. | **Por qué:** En una cocina real las manos pueden estar húmedas o con harina y el teléfono suele dejarse sobre una repisa. Un scroll largo obliga a tocar la pantalla constantemente. El modo guiado presenta un paso a la vez con tipografía de alto contraste, barra de progreso y botones amplios. |
| **Control de Tiempos** | Solo se informaban los minutos en texto plano sin ninguna interacción. | **Temporizador de Cocina Integrado con Alerta y Atajos Rápidos**. | **Por qué:** Evita que el usuario tenga que salir de la aplicación para buscar el reloj o cronómetro del sistema operativo. Incluye botones de un toque (+1, +3, +5 min) y aviso al cumplirse el tiempo. |
| **Ambiente de Iluminación** | Únicamente tema claro estilo papel pergamino. | **Modo Oscuro Artesanal Persistente (`ThemeProvider`)**. | **Por qué:** Muchos usuarios cocinan o cenan con luz cálida o tenue. El modo oscuro reduce la fatiga visual, ahorra batería en pantallas OLED y mantiene la identidad rústica con tonos carbón y bronce. El estado se guarda automáticamente en `SharedPreferences`. |
| **Cálculo de Comensales** | El número de porciones era un texto informativo fijo. | **Escalador Dinámico y Proporcional de Ingredientes**. | **Por qué:** Permite cocinar para una sola persona o para grupos grandes sin errores de cálculo en las proporciones de sal, harina o líquidos. |
| **Compartir Recetas** | Icono decorativo sin acción funcional asociada. | **Generador y Exportador de Ficha Culinaria al Portapapeles**. | **Por qué:** Permite enviar la lista completa de compras e instrucciones formateadas directamente por WhatsApp, Telegram o notas de compra con un solo toque. |
| **Filtros de Búsqueda** | Solo categorías en chips horizontales. | **Filtro Avanzado Combinado (Categoría + Dificultad + Tiempo Total)**. | **Por qué:** Resuelve el caso de uso del usuario que necesita resolver una comida con prisa (ej. "tengo menos de 15 minutos y busco algo fácil"). |
| **Diseño y Tipografía** | Diseños estáticos basados en imágenes genéricas. | **Ilustraciones Vectoriales Procedurales (`CulinaFoodGraphic`)**. | **Por qué:** Cero consumo de ancho de banda, tiempos de carga instantáneos sin fallos de red por imágenes caídas y estética artesanal homogénea. |
| **Seguridad de Interfaz** | Desbordamientos visuales ocasionales (*overflows*) en pantallas angostas. | **Diseño Responsivo con Manejo Estricto de Constraints (`Expanded` / `Flexible`)**. | **Por qué:** Garantiza visualización perfecta en cualquier resolución y densidad de pantalla sin cortes de texto ni advertencias en el árbol de widgets. |

---

## 5. Descripción Detallada de los "Pluses" de Valor Agregado

### Plus 1: Modo Cocina Guiada Paso a Paso
* **Archivo:** `lib/presentation/screens/cooking_mode_screen.dart`
* **Acceso:** Botón principal destacado en la parte inferior de cualquier receta.
* **Componentes:**
  * Indicador de progreso superior `LinearProgressIndicator` con porcentaje calculado en tiempo real.
  * Tarjeta central de lectura optimizada con tamaño de fuente aumentado (`20pt`) para lectura a distancia.
  * Panel desplegable con la lista de ingredientes calculada para las porciones activas sin perder el paso actual.
  * Botones grandes de navegación ("Anterior", "Siguiente") y diálogo celebratorio al completar la receta.

### Plus 2: Temporizador Digital de Cocina
* **Archivo:** Integrado en el Modo Cocina.
* **Funcionamiento:** Implementado con `dart:async` (`Timer.periodic`) y retroalimentación háptica (`HapticFeedback`).
* **Características:** Botones para pausar, reanudar, reiniciar y presets rápidos para sumar minutos de hervor u horneado con un solo toque.

### Plus 3: Modo Oscuro Artesanal (Dark Mode)
* **Archivos:** `lib/presentation/providers/theme_provider.dart` y `lib/presentation/theme/app_theme.dart`
* **Acceso:** Interruptor interactivo en la sección de Ajustes dentro de "Mi Perfil".
* **Diseño:** Paleta de colores cálida (`#141311` y `#1E1C1A`) inspirada en maderas oscuras y cocina rústica, respetando las guías de contraste WCAG AA.

### Plus 4: Compartir Ficha de Receta al Portapapeles
* **Archivo:** `lib/presentation/screens/recipe_detail_screen.dart`
* **Acceso:** Botón de compartir en la barra superior.
* **Funcionamiento:** Genera un texto limpio estructurado con título, tiempos, porciones seleccionadas, lista de ingredientes con cantidades exactas y pasos numerados.

### Plus 5: Filtro por Tiempo Máximo de Cocción
* **Archivos:** `lib/presentation/providers/recipe_provider.dart` y `lib/presentation/screens/explore_screen.dart`
* **Opciones:** Menos de 15 minutos, menos de 30 minutos y menos de 45 minutos.

---

## 6. Verificación y Calidad de Código

### Pruebas Automatizadas
El proyecto cuenta con suites de pruebas unitarias y de widgets en el directorio `/test`:
* **`widget_test.dart`**: Prueba de renderizado de la pantalla de bienvenida (*Splash Screen*), tipografías y animación inicial.
* **`recipe_crud_test.dart`**:
  * Prueba del algoritmo de escalado proporcional de ingredientes.
  * Prueba de creación de nuevas recetas en el proveedor (*Create*).
  * Prueba de filtrado reactivo por categoría y búsqueda textual (*Read*).
  * Prueba de modificación de recetas y alternancia de favoritos (*Update*).
  * Prueba de eliminación de recetas (*Delete*).

### Análisis Estático
El proyecto mantiene **cero advertencias de linting** bajo las reglas recomendadas de Flutter y Dart (`flutter analyze`), asegurando buenas prácticas de Clean Code, variables tipadas, métodos puros y prevención de pérdidas de memoria con `dispose()` en controladores y temporizadores.
