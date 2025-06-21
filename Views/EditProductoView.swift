//
//  EditProductoView.swift
//  jochos
//
//  Created by xav on 18/06/25.
//

import SwiftUI

struct EditProductoView: View {
    @State private var idProducto = ""
    @State private var nombre = ""
    @State private var precio = ""
    @State private var mensaje = ""
    @State private var mostrandoAlerta = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Editar Producto")
                .fontWeight(.bold)
                .font(.title3)
                .foregroundColor(Color("JochoGoldMed"))

            TextField("ID del Producto", text: $idProducto)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Nuevo Nombre", text: $nombre)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Nuevo Precio", text: $precio)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Guardar Cambios") {
                editarProducto()
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(idProducto.isEmpty || nombre.isEmpty || precio.isEmpty)

            Spacer()
        }
        .padding()
        .background(Color("JochoDarkBG"))
        .alert(isPresented: $mostrandoAlerta) {
            Alert(title: Text("Mensaje"), message: Text(mensaje), dismissButton: .default(Text("OK")))
        }
    }

    func editarProducto() {
        guard let id = UUID(uuidString: idProducto),
              let precioValue = Double(precio) else {
            mensaje = "Verifica el ID y el precio"
            mostrandoAlerta = true
            return
        }

        let producto = [
            "nombre": nombre,
            "precio": precioValue
        ] as [String: Any]

        guard let url = URL(string: "http://146.190.139.148:8080/productos/\(id.uuidString)"),
              let jsonData = try? JSONSerialization.data(withJSONObject: producto) else {
            mensaje = "Error al crear JSON o URL"
            mostrandoAlerta = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    mensaje = "Error: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    mensaje = "Producto actualizado correctamente"
                    idProducto = ""
                    nombre = ""
                    precio = ""
                } else {
                    mensaje = "Error al actualizar producto"
                }
                mostrandoAlerta = true
            }
        }.resume()
    }
}
