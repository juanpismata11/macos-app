//
//  EditRecetaView.swift
//  jochos
//
//  Created by xav on 18/06/25.
//

import SwiftUI

struct EditRecetaView: View {
    @State private var idReceta = ""
    @State private var productoID = ""
    @State private var ingredienteID = ""
    @State private var cantidad = ""
    @State private var mensaje = ""
    @State private var mostrandoAlerta = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Editar Receta")
                .fontWeight(.bold)
                .font(.title3)
                .foregroundColor(Color("JochoGoldMed"))

            TextField("ID de la Receta", text: $idReceta)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Nuevo ID de Producto", text: $productoID)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Nuevo ID de Ingrediente", text: $ingredienteID)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Nueva Cantidad", text: $cantidad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Guardar Cambios") {
                editarReceta()
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(idReceta.isEmpty || productoID.isEmpty || ingredienteID.isEmpty || cantidad.isEmpty)

            Spacer()
        }
        .padding()
        .background(Color("JochoDarkBG"))
        .alert(isPresented: $mostrandoAlerta) {
            Alert(title: Text("Mensaje"), message: Text(mensaje), dismissButton: .default(Text("OK")))
        }
    }

    func editarReceta() {
        guard let id = UUID(uuidString: idReceta),
              let productoUUID = UUID(uuidString: productoID),
              let ingredienteUUID = UUID(uuidString: ingredienteID),
              let cantidadValue = Double(cantidad) else {
            mensaje = "Verifica los datos"
            mostrandoAlerta = true
            return
        }

        let receta = [
            "productoId": productoUUID.uuidString,
            "ingredienteId": ingredienteUUID.uuidString,
            "cantidad": cantidadValue
        ] as [String : Any]

        guard let url = URL(string: "http://146.190.139.148:8080/recetas/\(id.uuidString)"),
              let jsonData = try? JSONSerialization.data(withJSONObject: receta) else {
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
                    mensaje = "Receta actualizada correctamente"
                    idReceta = ""
                    productoID = ""
                    ingredienteID = ""
                    cantidad = ""
                } else {
                    mensaje = "Error al actualizar receta"
                }
                mostrandoAlerta = true
            }
        }.resume()
    }
}
