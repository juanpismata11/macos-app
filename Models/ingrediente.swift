//
//  ingrediente.swift
//  jochos
//
//  Created by xav on 15/06/25.
//

import Foundation

struct Ingrediente: Identifiable, Codable {
    let id_ingrediente: Int
    var nombre: String
    var unidad_medida: UnidadMedida
    var stock_actual: Double
    var stock_minimo: Double
    var costo: Double
    var fecha_actualizacion: String?  
    
    enum UnidadMedida: String, Codable, CaseIterable {
        case unidad
        case kg
        case lt
        case gr
        case ml
    }
    
    var id: Int { id_ingrediente }
}
