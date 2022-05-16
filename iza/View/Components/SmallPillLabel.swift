//
//  LabelPill.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import SwiftUI


struct SmallPillLabel: View {
    var text: String
    
    var body: some View {
        ZStack {
            Text(text)
                .font(.system(size: 12.0, weight: .regular))
                .lineLimit(1)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.orange)
                .cornerRadius(5)
        }
    }
}
