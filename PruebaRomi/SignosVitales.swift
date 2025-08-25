//
//  SignosVitales.swift
//  PruebaRomi
//
//  Created by Jonathan Tijerina on 19/08/25.
//

import Foundation

// MARK: - Modelo mejorado de signos vitales
struct SignoVital: Identifiable, Codable {
    let id: UUID
    let fecha: Date
    let temperatura: String
    let presion: String
    let ritmoCardiaco: String
    
    // Constructor principal
    init(temperatura: String, presion: String, ritmoCardiaco: String) {
        self.id = UUID()
        self.fecha = Date()
        self.temperatura = temperatura
        self.presion = presion
        self.ritmoCardiaco = ritmoCardiaco
    }
    
    // Constructor completo para casos especiales
    init(id: UUID = UUID(), fecha: Date = Date(), temperatura: String, presion: String, ritmoCardiaco: String) {
        self.id = id
        self.fecha = fecha
        self.temperatura = temperatura
        self.presion = presion
        self.ritmoCardiaco = ritmoCardiaco
    }
    
    // Validación básica
    var esValido: Bool {
        return !temperatura.isEmpty && !presion.isEmpty && !ritmoCardiaco.isEmpty
    }
    
    // Formato de fecha para mostrar
    var fechaTexto: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: fecha)
    }
}

// MARK: - Clase principal para manejar datos (ahora con DataManager)
class DatosVitales: ObservableObject {
    @Published var lista: [SignoVital] = []
    private let dataManager = DataManager.shared
    
    init() {
        cargarDatos()
    }
    
    // MARK: - Operaciones principales
    
    func agregar(temperatura: String, presion: String, ritmo: String) {
        let nuevo = SignoVital(temperatura: temperatura, presion: presion, ritmoCardiaco: ritmo)
        
        // Validar antes de agregar
        guard nuevo.esValido else {
            print("⚠️ Datos no válidos, no se puede agregar")
            return
        }
        
        // Agregar a la lista local
        lista.insert(nuevo, at: 0)
        
        // Guardar en la base de datos
        dataManager.guardar(signosVitales: lista)
        
        print("✅ Nuevo registro agregado: Temp: \(temperatura)°C, Presión: \(presion), Ritmo: \(ritmo)ppm")
    }
    
    func eliminar(at indices: IndexSet) {
        // Eliminar de la lista local
        lista.remove(atOffsets: indices)
        
        // Actualizar base de datos
        dataManager.guardar(signosVitales: lista)
        
        print("🗑️ Registro(s) eliminado(s)")
    }
    
    func limpiarTodo() {
        lista.removeAll()
        dataManager.limpiarTodo()
        print("🧹 Todos los datos eliminados")
    }
    
    // MARK: - Carga de datos
    
    private func cargarDatos() {
        lista = dataManager.cargar()
        print("📂 Datos cargados: \(lista.count) registros")
    }
    
    // MARK: - Información útil
    
    var cantidadRegistros: Int {
        return lista.count
    }
    
    var ultimaActualizacion: Date? {
        return dataManager.ultimaActualizacion()
    }
    
    var tieneRegistros: Bool {
        return !lista.isEmpty
    }
}
