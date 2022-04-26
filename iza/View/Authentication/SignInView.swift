//
//  SignInView.swift
//  vut-iza
//
//  Created by Pavel Kratochvil on 22.04.2022.
//

import SwiftUI

struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var loginViewModel: LoginModel

    var body: some View {
        NavigationView {
        VStack {
            Spacer()
        
            Image("crushit_logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .clipped()
                .cornerRadius(150)
                .padding(.bottom, 30)
        
            VStack (alignment: .leading) {
                TextField("Email", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    
                    
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
            }
            .padding()
            
            Button(action: {
                
                // insert combine controls
                loginViewModel.signIn(email: email, password: password)
            }, label: {
                Text("Sign in")
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(8.0)
            })
            Spacer()
            NavigationLink("Sign up", destination: SignUpView())
            }
            .navigationTitle("Sign In")
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
