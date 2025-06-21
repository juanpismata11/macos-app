//
//  RecetasListView.swift
//  jochos
//
//  Created by xav on 18/06/25.
//

import SwiftUI

struct RecetasListView: View {
    @State private var recetas: [Receta] = []
    @State private var searchID = ""

    var recetasFiltradas: [Receta] {
        if searchID.isEmpty {
            return recetas
        } else {
            return recetas.filter {
                $0.id.uuidString.lowercased().contains(searchID.lowercased())
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Lista de Recetas")
                .fontWeight(.bold)
                .font(.title2)
                .foregroundColor(Color("JochoGoldBase"))

            TextField("Buscar por ID", text: $searchID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            List(recetasFiltradas) { receta in
                VStack(alignment: .leading) {
                    Text("Producto: \(receta.producto.nombre)")
                    Text("Ingrediente: \(receta.ingrediente.nombre)")
                    Text("Cantidad: \(receta.cantidad)")
                        .foregroundColor(.secondary)
                    Text("ID: \(receta.id.uuidString)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .padding(8)
                .background(Color("JochoGoldMuted").opacity(0.1))
                .cornerRadius(8)
            }
            .scrollContentBackground(.hidden)
            .background(Color("JochoDarkBG"))
        }
        .padding()
        .background(Color("JochoDarkBG"))
        .onAppear {
            Task {
                await fetchRecetas()
            }
        }
    }

    func fetchRecetas() async {
        guard let url = URL(string: "http://146.190.139.148:8080/recetas") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([Receta].self, from: data)
            DispatchQueue.main.async {
                self.recetas = decoded
            }
        } catch {
            print("Error al obtener recetas: \(error)")
        }
    }
}
