//
//  SignUpView.swift
//  vut-iza
//
//  Created by Pavel Kratochvil on 22.04.2022.
//

import SwiftUI

struct SignUpView: View {
    
    
    let genders = ["male", "female"]
    
    @EnvironmentObject var signUpModel: SignUpViewModel

    var body: some View {
        VStack {
            
            Spacer()
            
            VStack {
                Text("Personal Information")
                    
                TextField("Firts name", text: $signUpModel.firstName)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
        
                TextField("Last Name", text: $signUpModel.lastName)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
            
                HStack {
                    Text("Gender:")
                    Spacer()
                    Picker("Gender", selection: $signUpModel.gender) {
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
            
                TextField("Age", text: $signUpModel.age)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
            }
            
            Spacer()
            
            VStack {
                Text("Personal Information")
                
                TextField("Email", text: $signUpModel.email)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(5.0)

                SecureField("Password", text: $signUpModel.password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                
                SecureField("Repat Password", text: $signUpModel.passwordAgain)
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
                    signUpModel.signUp()
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
