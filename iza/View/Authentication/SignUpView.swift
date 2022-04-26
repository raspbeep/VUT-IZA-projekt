//
//  SignUpView.swift
//  vut-iza
//
//  Created by Pavel Kratochvil on 22.04.2022.
//

import SwiftUI

struct SignUpView: View {
    
    
    let genders = ["male", "female"]
    let categories = ["hobby", "profi"]
    
    @EnvironmentObject var loginModel: LoginViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
        VStack {
            Spacer()
            VStack (alignment: .leading){
                
                Text("Personal Information")
                    .foregroundColor(.secondary)
                
                EntryField(sfSymbolName: "person", placeholder: "First name", prompt: loginModel.firstNamePrompt, field: $loginModel.firstName)
                EntryField(sfSymbolName: "person", placeholder: "Last name", prompt: loginModel.lastNamePrompt, field: $loginModel.lastName)
                EntryField(sfSymbolName: "person.crop.circle", placeholder: "Nickname", prompt: loginModel.nicknamePrompt, field: $loginModel.nickName)
                
                DatePicker(selection: $loginModel.dateOfBirth, displayedComponents: .date) {
                                Text("Select a date")
                        .padding(.leading)
                }
                .padding(5)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
            
                VStack {
                    HStack {
                        Picker(selection: $loginModel.gender, label: EmptyView()) {
                            ForEach(Gender.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                                
                            }.pickerStyle(.segmented)
                        }
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(5.0)
                        
                    HStack {
                        Picker(selection: $loginModel.category, label: EmptyView()) {
                            ForEach(categories, id: \.self) {
                                Text($0)
                            }
                        }.pickerStyle(.segmented)
                    }
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                }
                
                    
            }
            
            Spacer()
            
            VStack (alignment: .leading) {
                
                Text("Credentials")
                    .foregroundColor(.secondary)
                
                EntryField(sfSymbolName: "envelope", placeholder: "Email Address", prompt: loginModel.emailPrompt, field: $loginModel.email)
                EntryField(sfSymbolName: "lock", placeholder: "Password", prompt: loginModel.passwordPrompt, field: $loginModel.password, isSecure: true)
                EntryField(sfSymbolName: "lock", placeholder: "Repeat password", prompt: loginModel.passwordAgainPrompt, field: $loginModel.passwordAgain, isSecure: true)
            }
            
            Spacer()
            
            VStack {
                Button(action: {
                    // insert combine controls
                    loginModel.signUp()
                }){
                    HStack {
                       Spacer()
                       Text("Sign Up")
                            .font(.headline)
                       Spacer()
                   }
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(8.0)
                }
                .opacity(loginModel.canSubmitSignUp ? 1 : 0.6)
                .disabled(!loginModel.canSubmitSignUp)
            }
            
            Spacer()
            
        }
        
        .padding(.top, 20)
        .padding(.leading)
        .padding(.trailing)
        .navigationTitle("Sign up")
        }
    }
}
    


struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        let loginModel = LoginViewModel()
        SignUpView()
            .environmentObject(loginModel)
    }
}
