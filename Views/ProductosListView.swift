//
//  ProductosListView.swift
//  jochos
//
//  Created by xav on 18/06/25.
//

import SwiftUI

struct ProductosListView: View {
    @State private var productos: [Producto] = []
    @State private var searchID = ""

    var productosFiltrados: [Producto] {
        if searchID.isEmpty {
            return productos
        } else {
            return productos.filter {
                $0.id.uuidString.lowercased().contains(searchID.lowercased())
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Lista de Productos")
                .fontWeight(.bold)
                .font(.title2)
                .foregroundColor(Color("JochoGoldBase"))

            TextField("Buscar por ID", text: $searchID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            List(productosFiltrados) { producto in
                VStack(alignment: .leading) {
                    Text(producto.nombre)
                        .font(.headline)
                    Text(String(format: "$ %.2f", producto.precio))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("ID: \(producto.id.uuidString)")
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
                await fetchProductos()
            }
        }
    }

    func fetchProductos() async {
        guard let url = URL(string: "http://146.190.139.148:8080/productos") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([Producto].self, from: data)
            DispatchQueue.main.async {
                self.productos = decoded
            }
        } catch {
            print("Error al obtener productos: \(error)")
        }
    }
}
