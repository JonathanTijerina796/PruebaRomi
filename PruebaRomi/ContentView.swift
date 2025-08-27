//
//  ContentView.swift
//  PruebaRomi
//
//  📱 VIEWS - La INTERFAZ de la arquitectura MVVM
//
//  ¿QUÉ HACE ESTE ARCHIVO?
//  - Contiene todas las VISTAS (UI) de la app
//  - Se conecta con el ViewModel para mostrar/manipular datos
//  - Maneja eventos del usuario (toques, swipes, texto)
//  - Contiene SOLO interfaz, SIN lógica de negocio (eso va en ViewModel)
//

import SwiftUI

// ═══════════════════════════════════════════════════════════════
// 📱 VISTA PRINCIPAL - Punto de entrada de la app
// ═══════════════════════════════════════════════════════════════

/// 🏠 VISTA PRINCIPAL DE LA APP
/// 🎯 PROPÓSITO: Contenedor principal con pestañas (TabView)
/// 🔗 CONECTA CON: SignosVitalesViewModel (como @StateObject)
/// 📱 CONTIENE: RegistrarView + HistorialView en pestañas
struct ContentView: View {
    
    // ┌─────────────────────────────────────────────────────────┐
    // │ 🧠 CONEXIÓN CON EL VIEWMODEL                           │
    // └─────────────────────────────────────────────────────────┘
    
    /// 🧠 ViewModel principal - EL CEREBRO de la app
    /// ⚡ @StateObject: SwiftUI crea y mantiene esta instancia
    /// 🔗 COMPARTIDO: Se pasa a RegistrarView y HistorialView
    /// 📡 OBSERVA: Cambios automáticos cuando signosVitales se actualiza
    @StateObject private var viewModel = SignosVitalesViewModel()
    
    var body: some View {
        // 📑 TabView - Crea pestañas en la parte inferior
        TabView {
            
            // ┌─────────────────────────────────────────────────────────┐
            // │ 📝 PESTAÑA 1: REGISTRAR NUEVOS SIGNOS VITALES          │
            // └─────────────────────────────────────────────────────────┘
            
            /// 📝 Vista para agregar nuevos registros médicos
            /// 🔗 RECIBE: viewModel (para llamar agregar() method)
            /// 📥 USUARIO: Escribe temperatura, presión, ritmo → toca "Guardar"
            /// 📤 RESULTADO: Nuevo registro en HistorialView
            RegistrarView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Registrar")
                }
            
            // ┌─────────────────────────────────────────────────────────┐
            // │ 📜 PESTAÑA 2: VER HISTORIAL DE REGISTROS               │
            // └─────────────────────────────────────────────────────────┘
            
            /// 📜 Vista para ver todos los registros guardados
            /// 🔗 RECIBE: viewModel (para mostrar signosVitales y eliminar())
            /// 📥 USUARIO: Ve lista, puede deslizar para eliminar
            /// 📤 RESULTADO: Lista actualizada automáticamente
            HistorialView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Historial")
                }
        }
        .accentColor(.blue) // 🎨 Color azul para elementos seleccionados
    }
}

// ═══════════════════════════════════════════════════════════════
// 📝 VISTA PARA REGISTRAR - Formulario de entrada de datos
// ═══════════════════════════════════════════════════════════════

/// 📝 VISTA PARA REGISTRAR NUEVOS SIGNOS VITALES
/// 🎯 PROPÓSITO: Formulario donde usuario ingresa datos médicos
/// 🔗 CONECTA CON: SignosVitalesViewModel (para llamar agregar())
/// 📱 CONTIENE: 3 TextFields + 1 Botón de guardar
struct RegistrarView: View {
    
    // ┌─────────────────────────────────────────────────────────┐
    // │ 🧠 CONEXIÓN CON EL VIEWMODEL                           │
    // └─────────────────────────────────────────────────────────┘
    
    /// 🧠 Referencia al ViewModel compartido
    /// ⚡ @ObservedObject: Observa cambios del ViewModel
    /// 🔗 VIENE DE: ContentView (se pasa como parámetro)
    /// 📞 USA: viewModel.agregar() para guardar datos
    @ObservedObject var viewModel: SignosVitalesViewModel
    
    // ┌─────────────────────────────────────────────────────────┐
    // │ 📝 ESTADO LOCAL DE LA VISTA (datos del formulario)     │
    // └─────────────────────────────────────────────────────────┘
    
    /// 🌡️ Campo de temperatura (enlazado con TextField)
    /// 💭 @State: Variable local que SwiftUI observa
    @State private var temperatura = ""
    
    /// 🩺 Campo de presión arterial (enlazado con TextField)
    @State private var presion = ""
    
    /// 💓 Campo de ritmo cardíaco (enlazado con TextField)
    @State private var ritmo = ""
    
    /// 🚨 Control para mostrar alerta de error
    @State private var mostrarAlerta = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                // Header mejorado
                VStack(spacing: 8) {
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text("Registrar Signos Vitales")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                .padding(.top, 20)
                
                // Formulario
                VStack(spacing: 18) {
                    // Campo Temperatura
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Temperatura (°C)", systemImage: "thermometer")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        TextField("Ej: 36.5", text: $temperatura)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
                    
                    // Campo Presión
                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.red)

                        TextField("Ej: 120/80", text: $presion)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Campo Ritmo
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.green)
                            Text("Ritmo Cardíaco (ppm)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        
                        TextField("Ej: 75", text: $ritmo)
                            .padding()
                            .background(Color.green.opacity(0.05))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                // ┌─────────────────────────────────────────────────────────┐
                // │ 💾 BOTÓN GUARDAR - Conexión VISTA → VIEWMODEL          │
                // └─────────────────────────────────────────────────────────┘
                
                /// 💾 BOTÓN PRINCIPAL - Guarda los datos ingresados
                /// 🎯 EVENTO: Cuando usuario toca "Guardar Registro"
                /// 🔍 VALIDACIÓN: Verifica que campos no estén vacíos
                /// 🧠 CONEXIÓN MVVM: Llama viewModel.agregar() (NO hace lógica aquí)
                Button(action: {
                    // ✅ Validación básica en la vista (solo UI)
                    if temperatura.isEmpty || presion.isEmpty || ritmo.isEmpty {
                        mostrarAlerta = true // 🚨 Mostrar alerta de error
                    } else {
                        // 🧠 CONEXIÓN MVVM: Delegar al ViewModel (TODA la lógica)
                        // 🔗 LLAMA A: SignosVitalesViewModel.agregar()
                        // 📤 RESULTADO: Nuevo registro aparece automáticamente en HistorialView
                        viewModel.agregar(temperatura: temperatura, presion: presion, ritmo: ritmo)
                        
                        // 🧹 Limpiar formulario después de guardar
                        limpiarCampos()
                    }
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Guardar Registro")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .alert("Error", isPresented: $mostrarAlerta) {
                Button("OK") { }
            } message: {
                Text("Por favor llena todos los campos")
            }
        }
    }
    
    private func limpiarCampos() {
        temperatura = ""
        presion = ""
        ritmo = ""
    }
}

// ═══════════════════════════════════════════════════════════════
// 📜 VISTA PARA HISTORIAL - Lista de registros guardados
// ═══════════════════════════════════════════════════════════════

/// 📜 VISTA PARA VER HISTORIAL DE SIGNOS VITALES
/// 🎯 PROPÓSITO: Mostrar lista de todos los registros guardados
/// 🔗 CONECTA CON: SignosVitalesViewModel (para mostrar signosVitales)
/// 📱 CONTIENE: Lista + funcionalidad para eliminar (swipe)
struct HistorialView: View {
    
    // ┌─────────────────────────────────────────────────────────┐
    // │ 🧠 CONEXIÓN CON EL VIEWMODEL                           │
    // └─────────────────────────────────────────────────────────┘
    
    /// 🧠 Referencia al ViewModel compartido
    /// ⚡ @ObservedObject: Observa cambios automáticamente
    /// 🔗 VIENE DE: ContentView (se pasa como parámetro)
    /// 👀 OBSERVA: viewModel.signosVitales para actualizar lista
    /// 📞 USA: viewModel.eliminar() para borrar registros
    @ObservedObject var viewModel: SignosVitalesViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Image(systemName: "heart.text.square.fill")
                        .font(.title)
                        .foregroundColor(.pink)
                    
                    VStack(alignment: .leading) {
                        Text("Historial Médico")
                            .font(.title3)
                            .fontWeight(.bold)
                        // 🔗 CONEXIÓN MVVM: Mostrar conteo automático
                        // 📊 viewModel.signosVitales.count se actualiza automáticamente
                        Text("\(viewModel.signosVitales.count) registros")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                
                // ┌─────────────────────────────────────────────────────────┐
                // │ 📋 ESTADO CONDICIONAL - Vacío vs Con datos             │
                // └─────────────────────────────────────────────────────────┘
                
                // 🔗 CONEXIÓN MVVM: Revisar si hay datos
                if viewModel.signosVitales.isEmpty {
                    // 📭 Estado vacío (no hay registros)
                    VStack(spacing: 15) {
                        Image(systemName: "tray")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("No hay registros")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                } else {
                    // ┌─────────────────────────────────────────────────────────┐
                    // │ 📜 LISTA PRINCIPAL - Mostrar todos los registros       │
                    // └─────────────────────────────────────────────────────────┘
                    
                    List {
                        // 🔗 CONEXIÓN MVVM: Iterar sobre datos del ViewModel
                        // ⚡ SwiftUI actualiza automáticamente cuando cambia signosVitales
                        ForEach(viewModel.signosVitales) { registro in
                            VStack(alignment: .leading, spacing: 8) {
                                // Fecha mejorada
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                    Text(fechaFormato.string(from: registro.fecha))
                                        .font(.headline)
                                    Spacer()
                                }
                                
                                // Datos
                                HStack {
                                    // Temperatura
                                    VStack {
                                        Image(systemName: "thermometer")
                                            .foregroundColor(.blue)
                                        Text(registro.temperatura)
                                            .fontWeight(.medium)
                                    }
                                    
                                    Spacer()
                                    
                                    // Presión básica
                                    Text("🩺 \(registro.presion)")
                                    
                                    Spacer()
                                    
                                    // Ritmo medio
                                    VStack {
                                        Text("💓")
                                        Text(registro.ritmoCardiaco)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        // ┌─────────────────────────────────────────────────────────┐
                        // │ 🗑️ ELIMINAR - Conexión VISTA → VIEWMODEL              │
                        // └─────────────────────────────────────────────────────────┘
                        
                        /// 🗑️ FUNCIÓN ELIMINAR por deslizar (swipe to delete)
                        /// 🎯 EVENTO: Cuando usuario desliza elemento hacia la izquierda
                        /// 🧠 CONEXIÓN MVVM: Llama viewModel.eliminar() (NO hace lógica aquí)
                        /// 🔗 LLAMA A: SignosVitalesViewModel.eliminar()
                        /// 📤 RESULTADO: Elemento desaparece automáticamente de la lista
                        .onDelete(perform: viewModel.eliminar)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

let fechaFormato: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    ContentView()
}