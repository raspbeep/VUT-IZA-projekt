//
//  LabelPill.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import SwiftUI


struct CategoryPill: View {
    
    var categoryName: String
    var fontSize: CGFloat = 12.0
    
    var body: some View {
        ZStack {
            Text(categoryName)
                .font(.system(size: fontSize, weight: .regular))
                .lineLimit(1)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.orange)
                .cornerRadius(5)
        }
    }
}
