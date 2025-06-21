//
//  PrimaryButtonStyle.swift
//  jochos
//
//  Created by xav on 17/06/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(Color("JochoGoldBase"))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .font(.subheadline)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

