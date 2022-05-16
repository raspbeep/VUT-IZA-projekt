//
//  CircleButton.swift
//  iza
//
//  Created by Pavel Kratochvil on 14.05.2022.
//

import SwiftUI

struct CircleButton: View {
    let imageName: String
    let color: Color
    
    var body: some View {
        Circle()
            .fill(.white)
            .overlay(Circle().stroke(lineWidth: 6))
            .foregroundColor(color)
            .overlay(
                Image(systemName: imageName)
                    .foregroundColor(Color.black)
            )
            .frame(width: 80, height: 80)
    }
}
