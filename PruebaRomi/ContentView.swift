//
//  ContentView.swift
//  PruebaRomi
//
//  Created by Jonathan Tijerina on 19/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var datos = DatosVitales()
    
    var body: some View {
        TabView {
            RegistrarView(datos: datos)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Registrar")
                }
            
            HistorialView(datos: datos)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Historial")
                }
        }
        .accentColor(.blue)
    }
}

// Vista para registrar
struct RegistrarView: View {
    @ObservedObject var datos: DatosVitales
    @State private var temperatura = ""
    @State private var presion = ""
    @State private var ritmo = ""
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
                
                // Botón
                Button(action: {
                    if temperatura.isEmpty || presion.isEmpty || ritmo.isEmpty {
                        mostrarAlerta = true
                    } else {
                        datos.agregar(temperatura: temperatura, presion: presion, ritmo: ritmo)
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

// Vista del historial
struct HistorialView: View {
    @ObservedObject var datos: DatosVitales
    
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
                        Text("\(datos.lista.count) registros")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                
                if datos.lista.isEmpty {
                    // Estado vacío básico
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
                    // Lista
                    List {
                        ForEach(datos.lista) { registro in
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
                        .onDelete(perform: datos.eliminar)
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
