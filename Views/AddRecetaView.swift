//
//  AddRecetaView.swift
//  jochos
//
//  Created by xav on 18/06/25.
//

import SwiftUI

struct AddRecetaView: View {
    @State private var productoID = ""
    @State private var ingredienteID = ""
    @State private var cantidad = ""
    @State private var mensaje = ""
    @State private var mostrandoAlerta = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Agregar Receta")
                .fontWeight(.bold)
                .font(.title3)
                .foregroundColor(Color("JochoGoldMed"))

            TextField("ID del Producto", text: $productoID)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("ID del Ingrediente", text: $ingredienteID)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Cantidad", text: $cantidad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Guardar Receta") {
                guardarReceta()
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

    func guardarReceta() {
        guard let cantidadValue = Double(cantidad),
              let productoUUID = UUID(uuidString: productoID),
              let ingredienteUUID = UUID(uuidString: ingredienteID) else {
            mensaje = "Verifica los campos (IDs deben ser UUID)"
            mostrandoAlerta = true
            return
        }

        let receta = [
            "productoId": productoUUID.uuidString,
            "ingredienteId": ingredienteUUID.uuidString,
            "cantidad": cantidadValue
        ] as [String : Any]

        guard let url = URL(string: "http://146.190.139.148:8080/recetas"),
              let jsonData = try? JSONSerialization.data(withJSONObject: receta) else {
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
                    mensaje = "Receta guardada correctamente"
                    productoID = ""
                    ingredienteID = ""
                    cantidad = ""
                } else {
                    mensaje = "Error al guardar receta"
                }
                mostrandoAlerta = true
            }
        }.resume()
    }
}
