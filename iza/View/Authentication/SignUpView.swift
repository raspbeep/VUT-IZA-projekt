//
//  SignUpView.swift
//  vut-iza
//
//  Created by Pavel Kratochvil on 22.04.2022.
//

import SwiftUI

struct SignUpView: View {
    
    
    let genders = ["male", "female"]
    
    @EnvironmentObject var loginModel: LoginViewModel

    var body: some View {
        VStack {
            
            Spacer()
            
            VStack {
                Text("Personal Information")
                    
                TextField("Firts name", text: $loginModel.firstName)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
        
                TextField("Last Name", text: $loginModel.lastName)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
            
                HStack {
                    Text("Gender:")
                    Spacer()
                    Picker("Gender", selection: $loginModel.gender) {
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
            
                TextField("Age", text: $loginModel.age)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
            }
            
            Spacer()
            
            VStack {
                Text("Personal Information")
                
                TextField("Email", text: $loginModel.email)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(5.0)

                SecureField("Password", text: $loginModel.password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                
                SecureField("Repat Password", text: $loginModel.passwordAgain)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
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
            }
            
            Spacer()
            
        }
        .padding()
        .navigationTitle("Create account")
    }
}
    


struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
