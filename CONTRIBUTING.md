# Guía de Buenas Prácticas y Flujo de Trabajo - Culina 🍳

Este documento establece las normas de desarrollo, flujo de ramas Git y principios de Clean Code para el equipo de desarrollo de **Culina** (*Matías Tapia, Maximiliano Lopez, José-Luis Hidalgo*).

---

## 🌳 1. Estrategia de Ramas (Git Flow)

Trabajaremos bajo un flujo basado en dos ramas principales y ramas temporales de trabajo:

```
feature/*  fix/*
   │         │
   └──► PR ──┴──► develop (Integración activa)
                     │
                     └──► PR (Revisado & Aprobado) ──► main (Producción / Entregas oficiales)
```

### 1.1 Ramas Principales
- **`main`**: Rama protegida de producción y entrega.
  - **REGLA ESTRICTA**: Nadie puede hacer push directo a `main`.
  - Solo se mergea desde `develop` mediante Pull Request tras revisión y aprobación del líder del repositorio.
- **`develop`**: Rama base de integración y desarrollo activo.
  - Toda nueva funcionalidad o corrección se mergea aquí mediante Pull Request.

### 1.2 Ramas Temporales
Toda rama de trabajo debe crearse a partir de la versión más reciente de `develop`:

| Tipo | Prefijo | Ejemplo | Descripción |
| :--- | :--- | :--- | :--- |
| **Nueva funcionalidad** | `feature/` | `feature/pantalla-receta-timer` | Desarrollo de pantallas o casos de uso nuevos |
| **Corrección de errores** | `fix/` | `fix/overflow-login-screen` | Corrección de bugs o excepciones |
| **Refactorización** | `refactor/` | `refactor/recipe-repository` | Mejora de código sin cambiar comportamiento |
| **Pruebas** | `test/` | `test/user-profile-unit` | Adición o ajuste de pruebas unitarias/widgets |
| **Documentación** | `docs/` | `docs/actualizar-readme` | Cambios en README, diagramas o guías |

---

## 🚀 2. Flujo de Trabajo Paso a Paso

### Paso 1: Actualizar `develop` local
```bash
git checkout develop
git pull origin develop
```

### Paso 2: Crear tu rama de trabajo
```bash
git checkout -b feature/nombre-de-tu-tarea
```

### Paso 3: Realizar cambios y commitear siguiendo *Conventional Commits*
Usa mensajes claros con los prefijos estándar:
- `feat: agregar buscador en tiempo real en Explorar`
- `fix: corregir cálculo dinámico de porciones en receta`
- `refactor: desacoplar lógica de presentación hacia RecipeProvider`
- `style: ajustar padding y colores según diseño Figma`
- `test: agregar test unitario para escalado de ingredientes`

```bash
git add .
git commit -m "feat: implementar filtro por dificultad en pantalla explorar"
```

### Paso 4: Validaciones locales obligatorias (Clean Code)
Antes de subir tu rama, ejecuta en la terminal:
```bash
dart format .
flutter analyze
flutter test
```
*Si alguno de estos comandos falla o arroja advertencias, soluciónalas antes de continuar.*

### Paso 5: Subir la rama y abrir Pull Request
```bash
git push -u origin feature/nombre-de-tu-tarea
```
1. Ve a GitHub: [MaxiLP-ai/Culina](https://github.com/MaxiLP-ai/Culina).
2. Abre un **Pull Request** apuntando hacia **`develop`** (como rama base).
3. Completa la plantilla del PR (descripción, checklist y capturas si aplica).
4. Espera a que la integración continua (GitHub Actions CI) pase en verde y al menos un compañero revise el código antes del merge.

---

## 🧹 3. Principios de Clean Code y Arquitectura

1. **Separación de Responsabilidades (Clean Architecture)**:
   - `domain/`: Lógica de negocio y entidades puras de Dart (sin dependencias de Flutter ni plugins).
   - `data/`: Modelos de serialización, llamadas a repositorios y persistencia local (`SharedPreferences`).
   - `presentation/`: Widgets, vistas y gestores de estado (`Provider`).
2. **Nombres Significativos y Descriptivos**:
   - Variables y métodos en `camelCase` que indiquen claramente su propósito (ej. `calculateServings()`, no `calc()`).
   - Clases y widgets en `PascalCase` (ej. `FeaturedRecipeCard`).
3. **No Hardcodear Textos o Números Mágicos**:
   - Usa `AppColors` para colores y tamaños constantes en lugar de valores hexadecimales dispersos.
4. **Widgets Pequeños y Reutilizables**:
   - Si un método `build()` supera las 100 líneas, extrae sub-widgets o componentes dedicados en `presentation/widgets/`.
5. **Cero Logs en Producción**:
   - No dejes `print()` ni código comentado en las ramas principales.
