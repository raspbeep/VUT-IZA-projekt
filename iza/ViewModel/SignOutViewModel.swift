//
//  LoginViewModel.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import SwiftUI
import Firebase

class SignOutViewModel: ObservableObject {
    
    let auth = Auth.auth()
    @Published var signedIn: Bool = false
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }

    func signOut() {
        try? auth.signOut()
        self.signedIn = false
        print("*** **** **** **** ***")
        print("SIGNED OUT")
        print("*** **** **** **** ***")
    }
}
