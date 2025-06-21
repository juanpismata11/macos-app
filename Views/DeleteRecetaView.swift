//
//  DeleteRecetaView.swift
//  jochos
//
//  Created by xav on 18/06/25.
//

import SwiftUI

struct DeleteRecetaView: View {
    @State private var idReceta = ""
    @State private var mensaje = ""
    @State private var mostrandoAlerta = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Eliminar Receta")
                .fontWeight(.bold)
                .font(.title3)
                .foregroundColor(Color("JochoGoldMed"))

            TextField("ID de la Receta", text: $idReceta)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Eliminar") {
                eliminarReceta()
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(idReceta.isEmpty)

            Spacer()
        }
        .padding()
        .background(Color("JochoDarkBG"))
        .alert(isPresented: $mostrandoAlerta) {
            Alert(title: Text("Mensaje"), message: Text(mensaje), dismissButton: .default(Text("OK")))
        }
    }

    func eliminarReceta() {
        guard let id = UUID(uuidString: idReceta) else {
            mensaje = "ID inválido"
            mostrandoAlerta = true
            return
        }

        guard let url = URL(string: "http://146.190.139.148:8080/recetas/\(id.uuidString)") else {
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
                    mensaje = "Receta eliminada correctamente"
                    idReceta = ""
                } else {
                    mensaje = "Error al eliminar receta"
                }
                mostrandoAlerta = true
            }
        }.resume()
    }
}
