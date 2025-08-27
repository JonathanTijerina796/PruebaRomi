//
//  PruebaRomiApp.swift
//  PruebaRomi
//
//  🚀 PUNTO DE ENTRADA - Donde inicia toda la app
//
//  ¿QUÉ HACE ESTE ARCHIVO?
//  - Es el PUNTO DE ENTRADA principal de toda la aplicación
//  - Configura la ventana principal de la app
//  - Inicia el sistema MVVM completo
//  - Se ejecuta automáticamente cuando se abre la app
//

import SwiftUI

// ═══════════════════════════════════════════════════════════════
// 🚀 APLICACIÓN PRINCIPAL - Punto de entrada del sistema
// ═══════════════════════════════════════════════════════════════

/// 🚀 ESTRUCTURA PRINCIPAL DE LA APP
/// 🎯 PROPÓSITO: Punto de entrada y configuración inicial
/// 📱 INICIA: Todo el sistema MVVM desde aquí
/// 🔗 CONECTA CON: ContentView (vista principal)
@main // ← Esta anotación le dice a iOS: "Aquí inicia la app"
struct PruebaRomiApp: App {
    
    var body: some Scene {
        // 🏠 WindowGroup - Crea la ventana principal de la app
        WindowGroup {
            
            // ┌─────────────────────────────────────────────────────────┐
            // │ 🎬 INICIO DEL SISTEMA MVVM                             │
            // └─────────────────────────────────────────────────────────┘
            
            /// 🏠 VISTA PRINCIPAL - Donde inicia todo el flujo MVVM
            /// 🔗 CONECTA CON: ContentView.swift
            /// 🧠 CREA: SignosVitalesViewModel automáticamente
            /// 📱 RESULTADO: App con 2 pestañas (Registrar + Historial)
            /// 
            /// 📊 FLUJO COMPLETO:
            /// PruebaRomiApp → ContentView → ViewModel → Model → Persistencia
            ContentView()
        }
    }
}

/*
 ┌─────────────────────────────────────────────────────────────────┐
 │ 🎯 RESUMEN DE LA ARQUITECTURA COMPLETA                         │
 └─────────────────────────────────────────────────────────────────┘
 
 🚀 PruebaRomiApp.swift (ESTE ARCHIVO)
    ↓ inicia
 📱 ContentView.swift (VISTA PRINCIPAL)
    ↓ crea y conecta
 🧠 SignosVitalesViewModel.swift (LÓGICA DE NEGOCIO)
    ↓ usa
 📦 SignosVitales.swift (MODELO DE DATOS)
    ↓ se guarda en
 💾 UserDefaults (PERSISTENCIA LOCAL)
 
 ✨ RESULTADO: App médica completa con arquitectura MVVM profesional
 
 */
