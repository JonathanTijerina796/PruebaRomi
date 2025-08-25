//
//  SignosVitalesViewModel.swift
//  PruebaRomi
//
//  PASO 1: ViewModel básico - Solo estructura
//

import Foundation

// PASO 1: ViewModel básico
class SignosVitalesViewModel: ObservableObject {
    // Por ahora, solo esto:
    @Published var signosVitales: [SignoVital] = []
    
    init() {
        print("✅ ViewModel creado")
    }
}

/*
 🤓 EXPLICACIÓN PASO 1:
 
 ¿Qué acabamos de crear?
 
 1. ObservableObject - Le dice a SwiftUI: "¡Oye, observa esta clase!"
 2. @Published - Esta variable actualiza la UI automáticamente cuando cambia
 3. init() - Se ejecuta cuando se crea el ViewModel
 4. print() - Para que veas en la consola cuando se crea
 
 ¿Por qué empezar tan simple?
 - Vamos construcción paso a paso
 - Aseguramos que cada paso funcione
 - Es más fácil entender cada concepto
 
 */
