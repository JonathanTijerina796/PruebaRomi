//
//  SignosVitales.swift
//  PruebaRomi
//
//  Created by Jonathan Tijerina on 19/08/25.
//

import Foundation

// Modelo de signos vitales
struct SignoVital: Identifiable, Codable {
    var id = UUID()
    var fecha = Date()
    var temperatura: String
    var presion: String
    var ritmoCardiaco: String
    
    init(temperatura: String, presion: String, ritmoCardiaco: String) {
        self.temperatura = temperatura
        self.presion = presion
        self.ritmoCardiaco = ritmoCardiaco
    }
}

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
