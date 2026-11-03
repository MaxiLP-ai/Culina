## 📌 Descripción del Cambio
<!-- Explica brevemente qué resuelve o agrega este Pull Request -->

## 🎯 Tipo de Cambio
- [ ] 🚀 Nueva funcionalidad (`feat`)
- [ ] 🐛 Corrección de bug (`fix`)
- [ ] ♻️ Refactorización de código limpio (`refactor`)
- [ ] 🎨 Ajuste visual de interfaz / diseño (`style`)
- [ ] 🧪 Pruebas unitarias o de widgets (`test`)
- [ ] 📝 Documentación (`docs`)

## 🏛️ Capa Afectada (Clean Architecture)
- [ ] `domain/` (Entidades, contratos de repositorios)
- [ ] `data/` (Modelos, servicios locales / remotos, implementación de repositorios)
- [ ] `presentation/` (Pantallas, widgets, temas, gestión de estado con Providers)

## 📋 Lista de Verificación (Clean Code)
- [ ] La rama parte desde `develop` y tiene el formato correcto (`feature/nombre`, `fix/nombre`).
- [ ] El PR apunta a la rama **`develop`** (NO a `main`).
- [ ] Ejecuté `dart format .` para formatear el código según las convenciones.
- [ ] Ejecuté `flutter analyze` y no reporta advertencias ni errores.
- [ ] Ejecuté `flutter test` y todas las pruebas pasaron con éxito.
- [ ] No hay código muerto, `print()` innecesarios ni variables mágicas sin nombres descriptivos.
- [ ] Se mantuvo la separación de responsabilidades y las buenas prácticas de UI responsiva.

## 📸 Evidencia Visual (si aplica)
<!-- Adjunta capturas de pantalla o gifs si hubo cambios en la interfaz de usuario -->
