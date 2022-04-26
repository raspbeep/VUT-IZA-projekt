//
//  SettingsView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI


struct SettingsView: View {
    
    @EnvironmentObject var signOutModel: SignOutViewModel
    
    var body: some View {
            Form {
                Button(action: {
                    signOutModel.signOut()
                }, label: {
                    Text("Logout")
                        .foregroundColor(Color.blue)
                })
                Section(header: Text("ABOUT")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("v0.1")
                    }
                }
            }
            .navigationTitle("Settings")
    }
}


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
