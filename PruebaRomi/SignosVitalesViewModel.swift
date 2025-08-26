//
//  SignosVitalesViewModel.swift
//  PruebaRomi
//
//  PASO 1: ViewModel básico - Solo estructura
//

import Foundation

// PASO 1: ViewModel básico
class SignosVitalesViewModel: ObservableObject {
    
    @Published var signosVitales: [SignoVital] = []
    
    // PASO 3C: Clave para UserDefaults
    private let claveUserDefaults = "signos_vitales_romi"
    
    init() {
        print("✅ ViewModel creado")
        // PASO 3C: Cargar datos cuando se crea el ViewModel
        cargarDatos()
    }
    
    // PASO 3A: Método para agregar signos vitales
    func agregar(temperatura: String, presion: String, ritmo: String) {
        print("🔄 Agregando nuevo signo vital...")
        
        // Crear el nuevo signo vital
        let nuevo = SignoVital(
            temperatura: temperatura, 
            presion: presion, 
            ritmoCardiaco: ritmo
        )
        
        // Agregarlo al inicio de la lista
        signosVitales.insert(nuevo, at: 0)
        
        // PASO 3C: Guardar después de agregar
        guardarDatos()
        
        print("✅ Signo vital agregado. Total: \(signosVitales.count)")
    }
    
    // PASO 3B: Método para eliminar signos vitales
    func eliminar(at indices: IndexSet) {
        print("🗑️ Eliminando \(indices.count) signo(s) vital(es)...")
        
        // Eliminar los elementos seleccionados
        signosVitales.remove(atOffsets: indices)
        
        // PASO 3C: Guardar después de eliminar
        guardarDatos()
        
        print("✅ Elementos eliminados. Total restante: \(signosVitales.count)")
    }
    
    // PASO 3C: Métodos de persistencia
    private func guardarDatos() {
        print("💾 Guardando datos...")
        
        do {
            let data = try JSONEncoder().encode(signosVitales)
            UserDefaults.standard.set(data, forKey: claveUserDefaults)
            print("✅ Datos guardados exitosamente")
        } catch {
            print("❌ Error al guardar: \(error)")
        }
    }
    
    private func cargarDatos() {
        print("📂 Cargando datos...")
        
        guard let data = UserDefaults.standard.data(forKey: claveUserDefaults) else {
            print("📂 No hay datos previos guardados")
            return
        }
        
        do {
            signosVitales = try JSONDecoder().decode([SignoVital].self, from: data)
            print("✅ Datos cargados: \(signosVitales.count) registros")
        } catch {
            print("❌ Error al cargar datos: \(error)")
        }
    }
}


 
