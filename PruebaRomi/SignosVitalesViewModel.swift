//
//  SignosVitalesViewModel.swift
//  PruebaRomi

import Foundation

// MARK: - SignosVitalesViewModel
class SignosVitalesViewModel: ObservableObject {
    @Published var signosVitales: [SignoVital] = []
    private let claveUserDefaults = "signos_vitales_romi"
    
    init() {
        print("🧠 ViewModel creado - Iniciando sistema MVVM")
        cargarDatos()
    }
    
    // MARK: - Métodos Públicos
    func agregar(temperatura: String, presion: String, ritmo: String) {
        print("➕ Agregando nuevo signo vital...")
        
        let nuevo = SignoVital(
            temperatura: temperatura, 
            presion: presion, 
            ritmoCardiaco: ritmo
        )
        
        signosVitales.insert(nuevo, at: 0)
        guardarDatos()
        
        print("✅ Signo vital agregado. Total: \(signosVitales.count)")
    }
    
    func eliminar(at indices: IndexSet) {
        print("🗑️ Eliminando \(indices.count) signo(s) vital(es)...")
        
        signosVitales.remove(atOffsets: indices)
        guardarDatos()
        
        print("✅ Elementos eliminados. Total restante: \(signosVitales.count)")
    }
    
    // MARK: - Métodos Privados
    private func guardarDatos() {
        print("💾 Guardando datos en UserDefaults...")
        
        do {
            let data = try JSONEncoder().encode(signosVitales)
            UserDefaults.standard.set(data, forKey: claveUserDefaults)
            print("✅ Datos guardados exitosamente")
        } catch {
            print("❌ Error al guardar: \(error)")
        }
    }
    
    private func cargarDatos() {
        print("📂 Cargando datos desde UserDefaults...")
        
        guard let data = UserDefaults.standard.data(forKey: claveUserDefaults) else {
            print("📂 No hay datos previos guardados (primera vez usando la app)")
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


 
