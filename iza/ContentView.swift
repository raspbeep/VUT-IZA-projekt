//
//  ContentView.swift
//  vut-iza
//
//  Created by Pavel Kratochvil on 20.04.2022.
//

import SwiftUI
import UIKit
import Firebase

struct ContentView: View {
    
    @EnvironmentObject var loginModel: LoginViewModel
    
    var body: some View {
        
        VStack {
            if loginModel.signedIn {
                VStack {
                    TabBar()
                }
            } else {
                SignInView()
            }
        }.onAppear {
            loginModel.signedIn = loginModel.isSignedIn
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let loginModel = LoginViewModel()
            ContentView()
                .environmentObject(loginModel)
            ContentView()
                .environmentObject(loginModel)
                .colorScheme(.dark)
                .background(Color.black)
        }
    }
}
