//
//  SignInView.swift
//  vut-iza
//
//  Created by Pavel Kratochvil on 22.04.2022.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var loginModel: LoginViewModel

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
                
                EntryField(sfSymbolName: "envelope", placeholder: "Email Address", prompt: loginModel.emailPrompt, field: $loginModel.email)
                EntryField(sfSymbolName: "lock", placeholder: "Password", field: $loginModel.password, isSecure: true)
            
            Button(action: {
                Task {
                    await loginModel.signIn()
                }
                
            }, label: {
                Text("Sign in")
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(8.0)
            })
            .opacity(loginModel.canSubmitSignIn ? 1 : 0.6)
            .disabled(!loginModel.canSubmitSignIn)
            
            Spacer()
            NavigationLink("Sign up", destination: SignUpView())
            }
            .padding()
            .navigationTitle("Sign In")
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        let loginModel = LoginViewModel()
        SignInView()
            .environmentObject(loginModel)
    }
}
