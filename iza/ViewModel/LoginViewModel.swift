//
//  LoginViewModel.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import SwiftUI
import Firebase

class LoginViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var gender = "male"
    @Published var age = ""
    @Published var email = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    
    
    
    
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
        
    func signUp() {
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
