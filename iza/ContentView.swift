//
//  ContentView.swift
//  vut-iza
//
//  Created by Pavel Kratochvil on 20.04.2022.
//

import SwiftUI
import UIKit
import Firebase

class LoginModel: ObservableObject {
    let auth = Auth.auth()
    @Published var signedIn: Bool = false
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
            auth.signIn(withEmail: email, password: password) { [weak self] result, error in
                guard result != nil, error == nil else {
                    print(error!)
                    return
                }
                print("*** **** **** **** ***")
                print("SIGNED IN")
                print("*** **** **** **** ***")
                DispatchQueue.main.async {
                    self?.signedIn = true
                }
            }
    }
        
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                print(error!)
                return
            }
            print("*** **** **** **** ***")
            print("SIGNED UP")
            print("*** **** **** **** ***")
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signOut() {
        try? auth.signOut()
        self.signedIn = false
        print("*** **** **** **** ***")
        print("SIGNED OUT")
        print("*** **** **** **** ***")
    }
}

struct ContentView: View {
    
    @EnvironmentObject var loginViewModel: LoginModel
    
    
    var body: some View {
        
        VStack {
            if loginViewModel.signedIn {
                VStack {
                    TabBar()
                }
            } else {
                SignInView()
            }
        }.onAppear {
            loginViewModel.signedIn = loginViewModel.isSignedIn
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let loginModel = LoginModel()
            ContentView()
                .environmentObject(loginModel)
            ContentView()
                .environmentObject(loginModel)
                .colorScheme(.dark)
                .background(Color.black)
        }
    }
}
