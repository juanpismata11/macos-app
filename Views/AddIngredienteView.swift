//
//  AddIngredienteView.swift
//  jochos
//
//  Created by xav on 17/06/25.
//

import SwiftUI

struct AddIngredienteView: View {
    @State private var name = ""
    @State private var quantity = ""
    @State private var unit = ""
    @State private var costo = ""
    @State private var stockMin = ""
    
    @State private var mensaje = ""
    @State private var mostrandoAlerta = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Agregar Ingrediente")
                .fontWeight(.bold)
                .font(.title3)
                .foregroundColor(Color("JochoGoldMed"))

            TextField("Nombre", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Cantidad Inicial", text: $quantity)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Unidad (ej. unidad, kg, lt, gr, ml)", text: $unit)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Costo", text: $costo)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Stock mínimo", text: $stockMin)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Guardar") {
                guardarIngrediente()
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

    func guardarIngrediente() {
        guard let stockActual = Double(quantity),
              let stockMinimo = Double(stockMin),
              let costoValue = Double(costo) else {
            mensaje = "Verifica los datos numéricos"
            mostrandoAlerta = true
            return
        }

        let ingrediente = [
            "nombre": name,
            "unidadMedida": unit,
            "stockActual": stockActual,
            "stockMinimo": stockMinimo,
            "costo": costoValue
        ] as [String: Any]

        guard let url = URL(string: "http://146.190.139.148:8080/ingredientes"),
              let jsonData = try? JSONSerialization.data(withJSONObject: ingrediente) else {
            mensaje = "Error al crear JSON o URL"
            mostrandoAlerta = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    mensaje = "Error: \(error.localizedDescription)"
                } else if let response = response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 201 {
                    mensaje = "Ingrediente guardado correctamente"
                    name = ""
                    quantity = ""
                    unit = ""
                    costo = ""
                    stockMin = ""
                } else {
                    mensaje = "Error al guardar ingrediente (status \(String(describing: (response as? HTTPURLResponse)?.statusCode)))"
                }
                mostrandoAlerta = true
            }
        }.resume()
    }
}
