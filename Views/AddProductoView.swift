//
//  AddProductoView.swift
//  jochos
//
//  Created by xav on 18/06/25.
//

import SwiftUI

struct AddProductoView: View {
    @State private var nombre = ""
    @State private var precio = ""
    @State private var mensaje = ""
    @State private var mostrandoAlerta = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Agregar Producto")
                .fontWeight(.bold)
                .font(.title3)
                .foregroundColor(Color("JochoGoldMed"))

            TextField("Nombre", text: $nombre)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Precio", text: $precio)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Guardar") {
                guardarProducto()
            }
            .buttonStyle(PrimaryButtonStyle())

            Spacer()
        }
        .padding()
        .background(Color("JochoDarkBG"))
        .alert(isPresented: $mostrandoAlerta) {
            Alert(title: Text("Mensaje"), message: Text(mensaje), dismissButton: .default(Text("OK")))
        }
    }

    func guardarProducto() {
        guard let precioValue = Double(precio) else {
            mensaje = "Precio inválido"
            mostrandoAlerta = true
            return
        }

        let producto = [
            "nombre": nombre,
            "precio": precioValue
        ] as [String : Any]

        guard let url = URL(string: "http://146.190.139.148:8080/productos"),
              let jsonData = try? JSONSerialization.data(withJSONObject: producto) else {
            mensaje = "Error al crear JSON o URL"
            mostrandoAlerta = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    mensaje = "Error: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                    mensaje = "Producto guardado correctamente"
                    nombre = ""
                    precio = ""
                } else {
                    mensaje = "Error al guardar producto"
                }
                mostrandoAlerta = true
            }
        }.resume()
    }
}
