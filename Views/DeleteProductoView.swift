//
//  DeleteProductoView.swift
//  jochos
//
//  Created by xav on 18/06/25.
//

import SwiftUI

struct DeleteProductoView: View {
    @State private var idProducto = ""
    @State private var mensaje = ""
    @State private var mostrandoAlerta = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Eliminar Producto")
                .fontWeight(.bold)
                .font(.title3)
                .foregroundColor(Color("JochoGoldMed"))

            TextField("ID del Producto", text: $idProducto)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Eliminar") {
                eliminarProducto()
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(idProducto.isEmpty)

            Spacer()
        }
        .padding()
        .background(Color("JochoDarkBG"))
        .alert(isPresented: $mostrandoAlerta) {
            Alert(title: Text("Mensaje"), message: Text(mensaje), dismissButton: .default(Text("OK")))
        }
    }

    func eliminarProducto() {
        guard let id = UUID(uuidString: idProducto) else {
            mensaje = "ID inválido"
            mostrandoAlerta = true
            return
        }

        guard let url = URL(string: "http://146.190.139.148:8080/productos/\(id.uuidString)") else {
            mensaje = "URL inválida"
            mostrandoAlerta = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    mensaje = "Error: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
                    mensaje = "Producto eliminado correctamente"
                    idProducto = ""
                } else {
                    mensaje = "Error al eliminar producto"
                }
                mostrandoAlerta = true
            }
        }.resume()
    }
}
