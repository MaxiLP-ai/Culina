# 🍲 Culina - Cocina Artesanal Móvil

> Aplicación móvil desarrollada en Flutter con arquitectura limpia (MVVM + Provider), persistencia de datos local y diseño fiel al sistema de diseño creado en Figma.

Proyecto para la asignatura de **Desarrollo de Aplicaciones Móviles (DAM)** - *Universidad Técnica Federico Santa María*.

---

## 👥 Integrantes del Equipo
- **Matías Tapia**
- **Maximiliano Lopez**
- **José-Luis Hidalgo**

---

## 📱 Pantallas y Funcionalidades
1. **Inicio de Sesión y Registro (`LoginScreen`)**:
   - Selector interactivo entre Iniciar Sesión y Registro.
   - Validaciones de formulario (email y contraseña con opción de ocultar/mostrar).
2. **Menú Principal (`HomeScreen`)**:
   - Saludo personalizado con avatar dinámico.
   - Categorías con contadores en tiempo real (`Desayunos`, `Pastas`, `Almuerzos`, etc.).
   - Tarjeta destacada con ilustración artesanal, botón de favoritos y acceso a cocción.
   - Carrusel de recetas rápidas de menos de 25 minutos.
3. **Explorador (`ExploreScreen`)**:
   - Buscador en vivo por nombre, ingrediente o categoría.
   - Filtros modales por nivel de dificultad y categorías.
4. **Creación y Edición de Recetas (`CreateRecipeScreen` - CRUD)**:
   - Formulario completo con validaciones numéricas y de texto.
   - Selector visual de 12 íconos de comida y paleta de 6 colores temáticos (*Olivo, Trigo, Trufa, Terracota, Cacao, Cúrcuma*).
   - Gestión dinámica de ingredientes y pasos con previsualización en vivo.
5. **Favoritos / Mis Guardadas (`FavoritesScreen`)**:
   - Gestión de recetas guardadas con filtrado rápido y acción de deshacer.
6. **Perfil de Usuario (`ProfileScreen`)**:
   - Estadísticas de recetas publicadas, guardadas y categoría preferida.
   - Biografía culinaria y tags gastronómicos editables.
   - Listado de creaciones publicadas con opciones de edición y eliminación segura.
7. **Detalle de Receta (`RecipeDetailScreen`)**:
   - **Calculadora interactiva de porciones**: selector `[ - ]  2  [ + ]` que recalcula las cantidades de todos los ingredientes al instante.
   - Lista interactiva de ingredientes con casillas de verificación.
   - Pasos detallados de preparación numerados.

---

## 🏛️ Estructura de Capas (Clean Architecture)

```
lib/
├── data/
│   ├── models/            # Mapeo de datos (RecipeModel, UserModel)
│   ├── repositories/      # Implementación del repositorio
│   └── services/          # Persistencia SharedPreferences y AuthService
├── domain/
│   ├── entities/          # Modelos de dominio puros (Recipe, Ingredient, UserProfile)
│   └── repositories/      # Interfaces de repositorio
├── presentation/
│   ├── providers/         # ViewModels / Manejo de estado con Provider
│   ├── screens/           # Pantallas completas
│   ├── theme/             # Paleta de colores y tipografía Playfair / Sans
│   └── widgets/           # Widgets reutilizables responsivos
└── main.dart
```

---

## 🛠️ Tecnologías y Dependencias
- **Flutter 3.x / Dart 3.x**
- [`provider`](https://pub.dev/packages/provider): Inyección de dependencias y reactividad.
- [`shared_preferences`](https://pub.dev/packages/shared_preferences): Persistencia de datos local.
- [`google_fonts`](https://pub.dev/packages/google_fonts): Tipografías Playfair Display y Plus Jakarta Sans.

---

## 🧪 Pruebas y Calidad de Código
```bash
# Formatear código
dart format .

# Análisis estático de Clean Code
flutter analyze

# Ejecución de pruebas unitarias y de widgets
flutter test
```

---

## 🌿 Flujo de Trabajo con Ramas
Consulta la [Guía de Buenas Prácticas (CONTRIBUTING.md)](./CONTRIBUTING.md) para conocer las reglas de ramas (`main`, `develop`, `feature/*`), convenciones de commits y el flujo de Pull Requests.
