# PruebaRomi - App de Signos Vitales

Una app para guardar datos médicos como temperatura, presión y ritmo cardíaco.

## Cómo usar la app

1. **Abrir el proyecto**
   - Abrir `PruebaRomi.xcodeproj` en Xcode
   - Seleccionar un simulador de iPhone
   - Presionar el botón Play

2. **Usar la app**
   - **Pestaña "Registrar"**: Escribir temperatura, presión y ritmo → Guardar
   - **Pestaña "Historial"**: Ver todos los registros guardados

## Archivos importantes

- `PruebaRomiApp.swift` - Donde inicia la app
- `ContentView.swift` - Las pantallas que ve el usuario
- `SignosVitalesViewModel.swift` - La lógica (guardar, eliminar datos)
- `SignosVitales.swift` - Cómo se ve un registro médico

## Arquitectura (MVVM)

Es como organizar tu código en 3 partes:

- **Model** (`SignosVitales.swift`) - Los datos (como una ficha médica)
- **View** (`ContentView.swift`) - Lo que ve el usuario (botones, textos)
- **ViewModel** (`SignosVitalesViewModel.swift`) - Conecta los datos con la pantalla

## Dónde se guardan los datos

Los registros se guardan automáticamente en el teléfono. Cuando cierres y abras la app, todavía estarán ahí.

---

*App hecha con SwiftUI*
