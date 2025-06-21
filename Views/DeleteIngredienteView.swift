//
//  DeleteIngredienteView.swift
//  jochos
//
//  Created by xav on 17/06/25.
//

import SwiftUI

struct DeleteIngredienteView: View {
    @State private var idIngrediente = ""
    @State private var mensaje = ""
    @State private var mostrandoAlerta = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Eliminar Ingrediente")
                .font(.title3)
                .foregroundColor(Color("JochoGoldMed"))
                .fontWeight(.bold)

            TextField("ID del Ingrediente", text: $idIngrediente)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Eliminar") {
                eliminarIngrediente()
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(idIngrediente.isEmpty)

            Spacer()
        }
        .padding()
        .background(Color("JochoDarkBG"))
        .alert(isPresented: $mostrandoAlerta) {
            Alert(title: Text("Mensaje"), message: Text(mensaje), dismissButton: .default(Text("OK")))
        }
    }

    func eliminarIngrediente() {
        guard let id = UUID(uuidString: idIngrediente),
              let url = URL(string: "http://146.190.139.148:8080/ingredientes/\(id.uuidString)") else {
            mensaje = "El ID no es válido (debe ser UUID)"
            mostrandoAlerta = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    mensaje = "Error: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 204 {
                        mensaje = "Ingrediente eliminado correctamente"
                        idIngrediente = ""
                    } else {
                        mensaje = "Error al eliminar ingrediente (status \(httpResponse.statusCode))"
                    }
                } else {
                    mensaje = "Respuesta inesperada del servidor"
                }
                mostrandoAlerta = true
            }
        }.resume()
    }
}
