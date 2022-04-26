//
//  vut_izaApp.swift
//  vut-iza
//
//  Created by Pavel Kratochvil on 22.04.2022.
//

import SwiftUI
import Firebase

@main
struct izaApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            let signInViewModel     = SignInViewModel()
            let signUpViewModel     = SignUpViewModel()
            let signOutViewModel    = SignOutViewModel()
            
            ContentView()
                .environmentObject(signInViewModel)
                .environmentObject(signUpViewModel)
                .environmentObject(signOutViewModel)
        }
    }
}
