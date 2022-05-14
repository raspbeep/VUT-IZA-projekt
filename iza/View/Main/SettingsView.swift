//
//  SettingsView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var loginModel: LoginViewModel
    @State var currentUser: User = User(id: "", uid: "", email: "", firstName: "", lastName: "", nickName: "", dateOfBirth: "", gender: "", category: "")
    
    var body: some View {
        VStack {
            HStack {
                Text("Profile")
                    .font(.system(size: 30, weight: .bold))
                Spacer()
            }
            .padding([.top, .horizontal])
            
            
            Spacer()
            Form {
                Section(header: Text("First name")) {
                    Text(currentUser.firstName)
                }
                Section(header: Text("Last name")) {
                    Text(currentUser.lastName)
                }
                Section(header: Text("Nickname")) {
                    Text(currentUser.nickName)
                }
                Section(header: Text("Gender")) {
                    Text(currentUser.gender)
                }

                Section(header: Text("Category")) {
                    Text(currentUser.category)
                }
                Section(header: Text("PROFILE")) {
                    Text(loginModel.auth.currentUser?.uid ?? "")
                }
                    
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("v0.1")
                    }
                }
                
                Section(header: Text("Logout")) {
                    Button(action: {
                        loginModel.signOut()
                    }, label: {
                        Text("Logout")
                            .foregroundColor(Color.blue)
                    })
                }
            }
        }
        .onAppear {
            Task {
                if let user = await loginModel.getCurrentUser() {
                    DispatchQueue.main.async {
                        self.currentUser = user
                    }
                }
            }
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}
