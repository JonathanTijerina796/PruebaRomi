//
//  SignosVitalesViewModel.swift
//  PruebaRomi
//
//  🧠 VIEWMODEL - El CEREBRO de la arquitectura MVVM
//  
//  ¿QUÉ HACE ESTE ARCHIVO?
//  - Es el intermediario entre las VISTAS (UI) y los DATOS
//  - Contiene toda la LÓGICA DE NEGOCIO de la app
//  - Maneja la PERSISTENCIA de datos (guardar/cargar)
//  - Se conecta con las vistas a través de @Published y @ObservedObject
//

import Foundation

// ═══════════════════════════════════════════════════════════════
// 🧠 VIEWMODEL PRINCIPAL - Centro de la arquitectura MVVM
// ═══════════════════════════════════════════════════════════════

class SignosVitalesViewModel: ObservableObject {
    
    // ┌─────────────────────────────────────────────────────────┐
    // │ 📱 PROPIEDADES QUE SE CONECTAN CON LA INTERFAZ (UI)    │
    // └─────────────────────────────────────────────────────────┘
    
    /// 📋 Lista principal de signos vitales
    /// 🔗 CONECTA CON: ContentView, RegistrarView, HistorialView
    /// ⚡ @Published: Actualiza la UI automáticamente cuando cambia
    @Published var signosVitales: [SignoVital] = []
    
    // ┌─────────────────────────────────────────────────────────┐
    // │ 💾 CONFIGURACIÓN PARA PERSISTENCIA DE DATOS            │
    // └─────────────────────────────────────────────────────────┘
    
    /// 🔑 Clave única para guardar datos en UserDefaults
    /// 💿 UserDefaults es como una "base de datos" súper simple del iPhone
    private let claveUserDefaults = "signos_vitales_romi"
    
    // ┌─────────────────────────────────────────────────────────┐
    // │ 🚀 INICIALIZACIÓN - Se ejecuta cuando se crea el VM    │
    // └─────────────────────────────────────────────────────────┘
    
    init() {
        print("🧠 ViewModel creado - Iniciando sistema MVVM")
        
        // 📂 Cargar datos anteriores desde el almacenamiento
        // 🔗 CONECTA CON: cargarDatos() método privado
        cargarDatos()
    }
    
    // ┌─────────────────────────────────────────────────────────┐
    // │ 📝 MÉTODOS PÚBLICOS - Se llaman desde las VISTAS      │ 
    // └─────────────────────────────────────────────────────────┘
    
    /// ➕ AGREGAR NUEVO SIGNO VITAL
    /// 🔗 LLAMADO DESDE: RegistrarView (cuando usuario toca "Guardar Registro")
    /// 📥 RECIBE: Datos del formulario (temperatura, presión, ritmo)
    /// 📤 HACE: Crea SignoVital, actualiza lista, guarda en persistencia
    func agregar(temperatura: String, presion: String, ritmo: String) {
        print("➕ Agregando nuevo signo vital...")
        
        // 🏗️ Crear el nuevo registro usando el MODEL (SignoVital)
        // 🔗 CONECTA CON: SignoVital.swift struct
        let nuevo = SignoVital(
            temperatura: temperatura, 
            presion: presion, 
            ritmoCardiaco: ritmo
        )
        
        // 📋 Agregarlo al INICIO de la lista (más reciente arriba)
        // ⚡ Como signosVitales es @Published, la UI se actualiza AUTOMÁTICAMENTE
        signosVitales.insert(nuevo, at: 0)
        
        // 💾 Guardar cambios en el almacenamiento permanente
        // 🔗 CONECTA CON: guardarDatos() método privado
        guardarDatos()
        
        print("✅ Signo vital agregado. Total: \(signosVitales.count)")
    }
    
    /// 🗑️ ELIMINAR SIGNOS VITALES
    /// 🔗 LLAMADO DESDE: HistorialView (.onDelete cuando usuario desliza para eliminar)
    /// 📥 RECIBE: índices de los elementos a eliminar
    /// 📤 HACE: Elimina elementos, actualiza lista, guarda cambios
    func eliminar(at indices: IndexSet) {
        print("🗑️ Eliminando \(indices.count) signo(s) vital(es)...")
        
        // 🗑️ Eliminar los elementos seleccionados del array
        // ⚡ Como signosVitales es @Published, la UI se actualiza AUTOMÁTICAMENTE
        signosVitales.remove(atOffsets: indices)
        
        // 💾 Guardar cambios en el almacenamiento permanente  
        // 🔗 CONECTA CON: guardarDatos() método privado
        guardarDatos()
        
        print("✅ Elementos eliminados. Total restante: \(signosVitales.count)")
    }
    
    // ┌─────────────────────────────────────────────────────────┐
    // │ 💾 MÉTODOS PRIVADOS - Persistencia de datos            │
    // └─────────────────────────────────────────────────────────┘
    
    /// 💾 GUARDAR DATOS EN EL ALMACENAMIENTO PERMANENTE
    /// 🔗 LLAMADO DESDE: agregar() y eliminar() - después de cada cambio
    /// 🎯 PROPÓSITO: Que los datos NO se pierdan al cerrar la app
    /// 🛠️ TECNOLOGÍA: UserDefaults + JSON encoding
    private func guardarDatos() {
        print("💾 Guardando datos en UserDefaults...")
        
        do {
            // 🔄 Convertir el array de SignoVital a formato JSON
            // 📦 JSONEncoder transforma objetos Swift → datos binarios
            let data = try JSONEncoder().encode(signosVitales)
            
            // 💿 Guardar en UserDefaults (almacenamiento del iPhone)
            // 🔑 Usar nuestra clave única para identificar estos datos
            UserDefaults.standard.set(data, forKey: claveUserDefaults)
            
            print("✅ Datos guardados exitosamente")
        } catch {
            // 🚨 Si algo sale mal, mostrar el error
            print("❌ Error al guardar: \(error)")
        }
    }
    
    /// 📂 CARGAR DATOS DEL ALMACENAMIENTO PERMANENTE
    /// 🔗 LLAMADO DESDE: init() - cuando se crea el ViewModel
    /// 🎯 PROPÓSITO: Recuperar datos guardados anteriormente
    /// 🛠️ TECNOLOGÍA: UserDefaults + JSON decoding
    private func cargarDatos() {
        print("📂 Cargando datos desde UserDefaults...")
        
        // 🔍 Buscar datos guardados con nuestra clave
        guard let data = UserDefaults.standard.data(forKey: claveUserDefaults) else {
            print("📂 No hay datos previos guardados (primera vez usando la app)")
            return
        }
        
        do {
            // 🔄 Convertir datos JSON → array de SignoVital
            // 📦 JSONDecoder transforma datos binarios → objetos Swift
            signosVitales = try JSONDecoder().decode([SignoVital].self, from: data)
            
            print("✅ Datos cargados: \(signosVitales.count) registros")
        } catch {
            // 🚨 Si los datos están corruptos, mostrar error
            print("❌ Error al cargar datos: \(error)")
        }
    }
}


 
