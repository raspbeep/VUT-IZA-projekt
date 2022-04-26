//
//  LoginViewModel.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import SwiftUI
import Firebase
import Foundation
import Combine


class LoginViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var gender = "male"
    @Published var dateOfBirth = Date()
    @Published var category = "hobby"
    @Published var email = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    
    @Published var isEmailCriteriaValid = false
    @Published var isPasswordCriteriaValid = false
    @Published var isPasswordConfirmValid = false
    @Published var isAgeValid = false
    @Published var canSubmitSignUp = false
    @Published var canSubmitSignIn = false
    private var cancellableSet: Set<AnyCancellable> = []
    
    var confirmPwPrompt: String {
            isPasswordConfirmValid ? "" : "Password fields to not match"
        }
        
        var emailPrompt: String {
            isEmailCriteriaValid ? "" : "Enter a valid email address"
        }
        
        var passwordPrompt: String {
            isPasswordCriteriaValid ? "" : "Must be at least 8 characters."
        }
        
//        var agePrompt: String {
//            isAgeValid ? "Year of birth" : "Year of birth (must be 21 years old)"
//        }
    
    
    let auth = Auth.auth()
    @Published var signedIn: Bool = false
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])")
    
    init() {
            $email
                .map { email in
                    return self.emailPredicate.evaluate(with: email)
                }
                .assign(to: \.isEmailCriteriaValid, on: self)
                .store(in: &cancellableSet)
            
            $password
                .map { password in
                    return password.count > 8
                }
                .assign(to: \.isPasswordCriteriaValid, on: self)
                .store(in: &cancellableSet)
            
//            $birthYear
//                .map { birthYear in
//                    return (Constants.currentYear - birthYear) >= 21
//                }
//                .assign(to: \.isAgeValid, on: self)
//                .store(in: &cancellableSet)
            
            Publishers.CombineLatest($password, $passwordAgain)
                .map { password, confirmPw in
                    return password == confirmPw
                }
                .assign(to: \.isPasswordConfirmValid, on: self)
                .store(in: &cancellableSet)
            
            Publishers.CombineLatest4($isEmailCriteriaValid, $isPasswordCriteriaValid, $isPasswordConfirmValid, $isAgeValid)
                .map { isEmailCriteriaValid, isPasswordCriteriaValid, isPasswordConfirmValid, isAgeValid in
                    return (isEmailCriteriaValid && isPasswordCriteriaValid && isPasswordConfirmValid && isAgeValid)
                }
                .assign(to: \.canSubmitSignUp, on: self)
                .store(in: &cancellableSet)
        
        Publishers.CombineLatest($isEmailCriteriaValid, $isPasswordCriteriaValid)
            .map { isEmailCriteriaValid, isPasswordCriteriaValid in
                return isEmailCriteriaValid && isPasswordCriteriaValid
            }
            .assign(to: \.canSubmitSignIn, on: self)
            .store(in: &cancellableSet)
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
        self.password = ""
        print("*** **** **** **** ***")
        print("SIGNED OUT")
        print("*** **** **** **** ***")
    }
}
