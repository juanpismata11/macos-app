//
//  IngredientesListView.swift
//  jochos
//
//  Created by xav on 17/06/25.
//

import SwiftUI

struct IngredientesListView: View {
    @StateObject private var viewModel = IngredientesViewModel()
    @State private var searchID = ""

    var ingredientesFiltrados: [Ingrediente] {
        if searchID.isEmpty {
            return viewModel.ingredientes
        } else {
            return viewModel.ingredientes.filter {
                $0.id.uuidString.lowercased().contains(searchID.lowercased())
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Inventario de Ingredientes")
                .fontWeight(.bold)
                .font(.title2)
                .foregroundColor(Color("JochoGoldBase"))

            TextField("Buscar por ID", text: $searchID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            List(ingredientesFiltrados) { ingrediente in
                VStack(alignment: .leading, spacing: 4) {
                    Text(ingrediente.nombre)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Text("• \(ingrediente.stockActual) \(ingrediente.unidadMedida)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("ID: \(ingrediente.id.uuidString)")
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
            viewModel.fetchIngredientes()
        }
    }
}
