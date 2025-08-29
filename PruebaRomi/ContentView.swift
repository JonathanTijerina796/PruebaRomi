//
//  ContentView.swift
//  PruebaRomi

import SwiftUI

// MARK: - Vista Principal
struct ContentView: View {
    @StateObject private var viewModel = SignosVitalesViewModel()
    
    var body: some View {
        TabView {
            RegistrarView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Registrar")
                }
            
            HistorialView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Historial")
                }
        }
        .accentColor(.blue)
    }
}

// MARK: - Vista para Registrar
struct RegistrarView: View {
    @ObservedObject var viewModel: SignosVitalesViewModel
    @State private var temperatura = ""
    @State private var presion = ""
    @State private var ritmo = ""
    @State private var mostrarAlerta = false
    @State private var mostrarConfirmacion = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                VStack(spacing: 8) {
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text("Registrar Signos Vitales")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                .padding(.top, 20)
                VStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Temperatura (°C)", systemImage: "thermometer")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        TextField("Ej: 36.5", text: $temperatura)
                            .keyboardType(.decimalPad)
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
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Presión Arterial", systemImage: "drop.fill")
                            .font(.headline)
                            .foregroundColor(.red)
                        
                        TextField("Ej: 120/80", text: $presion)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Ritmo Cardíaco (ppm)", systemImage: "heart.fill")
                            .font(.headline)
                            .foregroundColor(.green)
                        
                        TextField("Ej: 75", text: $ritmo)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.green.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
                }
                .padding(.horizontal)
                
                Button(action: {
                    if temperatura.isEmpty || presion.isEmpty || ritmo.isEmpty {
                        mostrarAlerta = true
                    } else {
                        viewModel.agregar(temperatura: temperatura, presion: presion, ritmo: ritmo)
                        limpiarCampos()
                        mostrarConfirmacion = true
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
            .alert("¡Datos Guardados!", isPresented: $mostrarConfirmacion) {
                Button("Perfecto") { }
            } message: {
                Text("Los signos vitales se han guardado exitosamente. Puedes verlos en la pestaña 'Historial'.")
            }
        }
    }
    
    // MARK: - Métodos Privados
    private func limpiarCampos() {
        temperatura = ""
        presion = ""
        ritmo = ""
    }
}

// MARK: - Vista del Historial
struct HistorialView: View {
    @ObservedObject var viewModel: SignosVitalesViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "heart.text.square.fill")
                        .font(.title)
                        .foregroundColor(.pink)
                    
                    VStack(alignment: .leading) {
                        Text("Historial Médico")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("\(viewModel.signosVitales.count) registros")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                
                if viewModel.signosVitales.isEmpty {
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
                    List {
                        ForEach(viewModel.signosVitales) { registro in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                    Text(fechaFormato.string(from: registro.fecha))
                                        .font(.headline)
                                    Spacer()
                                }
                                HStack {
                                    VStack {
                                        Image(systemName: "thermometer")
                                            .foregroundColor(.blue)
                                        Text(registro.temperatura)
                                            .fontWeight(.medium)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("🩺 \(registro.presion)")
                                    
                                    Spacer()
                                    VStack {
                                        Text("💓")
                                        Text(registro.ritmoCardiaco)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
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

// MARK: - Extensions
let fechaFormato: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    ContentView()
}
