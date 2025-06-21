//
//  JochoViewModel.swift
//  jochos
//
//  Created by xav on 16/06/25.
//


import Foundation

class IngredientesViewModel: ObservableObject {
    @Published var ingredientes: [Ingrediente] = []

    func fetchIngredientes() {
        guard let url = URL(string: "https://146.190.139.148/api/ingredientes") else { return } //aqui agreaga la api jp

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let decoded = try? JSONDecoder().decode([Ingrediente].self, from: data) {
                    DispatchQueue.main.async {
                        self.ingredientes = decoded
                    }
                }
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}

