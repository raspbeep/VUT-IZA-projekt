//
//  EntryField.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import SwiftUI

struct EntryField: View {
    var sfSymbolName: String?
    var placeholder: String
    var prompt: String?
    @Binding var field: String
    var isSecure = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let sfSymbolName = sfSymbolName {
                    Image(systemName: sfSymbolName)
                        .foregroundColor(.gray)
                        .font(.headline)
                        .frame(width: 20)
                }
                if isSecure {
                    SecureField(placeholder, text: $field)
                } else {
                    TextField(placeholder, text: $field)
                }
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(5.0)
            
            if let prompt = prompt {
                Text(prompt)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct EntryField_Previews: PreviewProvider {
    static var previews: some View {
        EntryField(sfSymbolName: "tray", placeholder: "Email Address", prompt: "Enter a valid email address", field: .constant(""))
    }
}
