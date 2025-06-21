//
//  ContentView.swift
//  jochos
//
//  Created by xav on 16/06/25.
//

import SwiftUI

struct ContentView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer(minLength: 40)

                Image("jochosLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)

                Text("Inventario")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("JochoGoldBase"))

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        //ingredientes
                        NavigationLink("Ver Inventario") { IngredientesListView() }
                        NavigationLink("Agregar Ingrediente") { AddIngredienteView() }
                        NavigationLink("Editar Ingrediente") { EditIngredienteView() }
                        NavigationLink("Eliminar Ingrediente") { DeleteIngredienteView() }

                        //productos
                        NavigationLink("Ver Productos") { ProductosListView() }
                        NavigationLink("Agregar Producto") { AddProductoView() }
                        NavigationLink("Editar Producto") { EditProductoView() }
                        NavigationLink("Eliminar Producto") { DeleteProductoView() }

                        //rcetas
                        NavigationLink("Ver Recetas") { RecetasListView() }
                        NavigationLink("Agregar Receta") { AddRecetaView() }
                        NavigationLink("Editar Receta") { EditRecetaView() }
                        NavigationLink("Eliminar Receta") { DeleteRecetaView() }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal)
                }

                Spacer(minLength: 40)
            }
            .padding(.horizontal)
            .background(Color("JochoDarkBG"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
