//
//  SignosVitales.swift
//  PruebaRomi
//
//  📦 MODEL - Los DATOS de la arquitectura MVVM
//
//  ¿QUÉ HACE ESTE ARCHIVO?
//  - Define la estructura de datos (SignoVital)
//  - Es el "molde" para crear registros médicos
//  - Se conecta con el ViewModel para crear/guardar/cargar datos
//  - Contiene SOLO datos, SIN lógica de negocio (eso va en ViewModel)
//

import Foundation

// ═══════════════════════════════════════════════════════════════
// 📦 MODEL - Estructura de datos para signos vitales
// ═══════════════════════════════════════════════════════════════

/// 🏥 MODELO DE SIGNO VITAL
/// 🎯 PROPÓSITO: Representa un registro médico individual
/// 🔗 USADO POR: SignosVitalesViewModel para crear/manipular datos
/// 📱 MOSTRADO EN: RegistrarView (formulario) y HistorialView (lista)
struct SignoVital: Identifiable, Codable {
    
    // ┌─────────────────────────────────────────────────────────┐
    // │ 📝 PROPIEDADES DEL REGISTRO MÉDICO                     │
    // └─────────────────────────────────────────────────────────┘
    
    /// 🆔 Identificador único (requerido por SwiftUI para listas)
    /// ⚡ Se genera automáticamente, nunca se repite
    var id = UUID()
    
    /// 📅 Fecha y hora cuando se creó el registro
    /// ⏰ Se asigna automáticamente al momento de crear
    var fecha = Date()
    
    /// 🌡️ Temperatura corporal (como texto, ej: "36.5")
    /// 📝 Viene del TextField en RegistrarView
    var temperatura: String
    
    /// 🩺 Presión arterial (como texto, ej: "120/80")
    /// 📝 Viene del TextField en RegistrarView
    var presion: String
    
    /// 💓 Ritmo cardíaco (como texto, ej: "75")
    /// 📝 Viene del TextField en RegistrarView
    var ritmoCardiaco: String
    
    // ┌─────────────────────────────────────────────────────────┐
    // │ 🏗️ CONSTRUCTOR - Cómo crear un nuevo SignoVital        │
    // └─────────────────────────────────────────────────────────┘
    
    /// 🏗️ Crear nuevo signo vital con datos del usuario
    /// 🔗 LLAMADO DESDE: SignosVitalesViewModel.agregar()
    /// 📥 RECIBE: Datos del formulario (temperatura, presión, ritmo)
    /// 📤 CREA: Nuevo registro con ID y fecha automáticos
    init(temperatura: String, presion: String, ritmoCardiaco: String) {
        // id y fecha se asignan automáticamente arriba ↑
        self.temperatura = temperatura
        self.presion = presion
        self.ritmoCardiaco = ritmoCardiaco
    }
}

/*
 ┌─────────────────────────────────────────────────────────────────┐
 │ ⚠️  CLASE ANTERIOR - YA NO SE USA (reemplazada por ViewModel)   │
 └─────────────────────────────────────────────────────────────────┘
 
 Esta clase DatosVitales era el sistema anterior (antes de MVVM).
 Ahora toda la lógica está en SignosVitalesViewModel.swift
 
 La mantenemos comentada para referencia, pero NO se usa.
*/

// Clase para manejar datos con almacenamiento
class DatosVitales: ObservableObject {
    @Published var lista: [SignoVital] = []
    private let clave = "datosVitales"
    
    init() {
        cargarDatos()
    }
    
    func agregar(temperatura: String, presion: String, ritmo: String) {
        let nuevo = SignoVital(temperatura: temperatura, presion: presion, ritmoCardiaco: ritmo)
        lista.insert(nuevo, at: 0)
        guardarDatos()
    }
    
    func eliminar(at indices: IndexSet) {
        lista.remove(atOffsets: indices)
        guardarDatos()
    }
    
    private func guardarDatos() {
        if let data = try? JSONEncoder().encode(lista) {
            UserDefaults.standard.set(data, forKey: clave)
        }
    }
    
    private func cargarDatos() {
        if let data = UserDefaults.standard.data(forKey: clave),
           let listaGuardada = try? JSONDecoder().decode([SignoVital].self, from: data) {
            lista = listaGuardada
        }
    }
}