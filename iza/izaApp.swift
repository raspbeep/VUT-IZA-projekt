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
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var firestoreManager = FirestoreManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginViewModel)
                .environmentObject(firestoreManager)
        }
    }
}
