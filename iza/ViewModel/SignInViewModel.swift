//
//  LoginViewModel.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import SwiftUI
import Firebase

class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    let auth = Auth.auth()
    @Published var signedIn: Bool = false
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn() {
        print("Password is")
        print(email)
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
}
