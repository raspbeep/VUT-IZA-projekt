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
    @Published var errorMessage = ""
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var nickName = ""
    @Published var gender = Gender.male
    @Published var dateOfBirth = Date()
    @Published var category = "hobby"
    @Published var email = ""
    @Published var password = ""
    @Published var passwordAgain = ""
    
    @Published var isEmailCriteriaValid = false
    @Published var isPasswordCriteriaValid = false
    @Published var isPasswordConfirmValid = false
    
    @Published var firstNameIsNotEmpty = false
    @Published var lastNameIsNotEmpty = false
    @Published var nicknameIsNotEmpty = false
    
    @Published var namesAreValid = false
    @Published var canSubmitSignUp = false
    @Published var canSubmitSignIn = false
    private var cancellableSet: Set<AnyCancellable> = []
    
    let currentYear = "2022"
    let currentMonth = "April"
    
    @State var listOfBoulders = [Boulder]()
    
    var passwordPrompt: String {
        isPasswordCriteriaValid ? "" : "Must be at least 8 characters."
    }
    
    var passwordAgainPrompt: String {
        isPasswordConfirmValid ? "" : "Password fields to not match"
    }
        
    var emailPrompt: String {
        isEmailCriteriaValid ? "" : "Enter a valid email address"
    }
    
    var firstNamePrompt: String {
        firstNameIsNotEmpty ? "" : "First name cannot be empty"
    }
    
    var lastNamePrompt: String {
        lastNameIsNotEmpty ? "" : "Last name cannot be empty"
    }
    
    var nicknamePrompt: String {
        nicknameIsNotEmpty ? "" : "Nickname cannot be empty"
    }
        
//        var agePrompt: String {
//            isAgeValid ? "Year of birth" : "Year of birth (must be 21 years old)"
//        }
    
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    @Published var signedIn: Bool = false
    var isSignedIn: Bool {
        if auth.currentUser != nil {
            return true
        } else {
            return false
        }
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
                    return password.count > 7
                }
                .assign(to: \.isPasswordCriteriaValid, on: self)
                .store(in: &cancellableSet)
            
            $firstName
                .map { name in
                    return name.count > 0
                }
                .assign(to: \.firstNameIsNotEmpty, on: self)
                .store(in: &cancellableSet)
        
            $lastName
                .map { name in
                    return name.count > 0
                }
                .assign(to: \.lastNameIsNotEmpty, on: self)
                .store(in: &cancellableSet)
            
            $nickName
                .map { password in
                    return password.count > 0
                }
                .assign(to: \.nicknameIsNotEmpty, on: self)
                .store(in: &cancellableSet)
                
            Publishers.CombineLatest($password, $passwordAgain)
                .map { password, confirmPw in
                    return password == confirmPw
                }
                .assign(to: \.isPasswordConfirmValid, on: self)
                .store(in: &cancellableSet)
        
            Publishers.CombineLatest3($firstNameIsNotEmpty, $lastNameIsNotEmpty, $nicknameIsNotEmpty)
            .map{ firstNameIsNotEmpty, lastNameIsNotEmpty, nicknameIsNotEmpty in
                return firstNameIsNotEmpty && lastNameIsNotEmpty && nicknameIsNotEmpty
            }
            .assign(to: \.namesAreValid, on: self)
            .store(in: &cancellableSet)
            
            Publishers.CombineLatest4($isEmailCriteriaValid, $isPasswordCriteriaValid, $isPasswordConfirmValid, $namesAreValid)
                .map { isEmailCriteriaValid, isPasswordCriteriaValid, isPasswordConfirmValid, namesAreValid in
                    return isEmailCriteriaValid && isPasswordCriteriaValid && isPasswordConfirmValid && namesAreValid
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
    
    func signIn() async {
        do {
            let authDataResult = try await auth.signIn(withEmail: email, password: password)
            let user = authDataResult.user
            
            print("Signed in as \(user.uid), with email \(user.email ?? "")")
            DispatchQueue.main.async {
                self.signedIn = true
            }
            print("*** **** **** **** ***")
            print("SIGNED IN")
            print("*** **** **** **** ***")
            
        } catch {
            print("There was an error signing in: \(error.localizedDescription.description)")
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func signUp() async {
        do {
            let authDataResult = try await auth.createUser(withEmail: email, password: password)
            let user = authDataResult.user
        
            print("Signed up as \(user.uid), with email \(user.email ?? "")")
            
            DispatchQueue.main.async {
                self.signedIn = true
            }
            
            print("*** **** **** **** ***")
            print("SIGNED UP")
            print("*** **** **** **** ***")
            createUserData()
        
        } catch {
            print("There was an error signing up: \(error.localizedDescription.description)")
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func signOut() {
        do {
            try? auth.signOut()
            self.signedIn = false
            self.password = ""
            self.passwordAgain = ""
            self.firstName = ""
            self.lastName = ""
            self.nickName = ""
            
            print("*** **** **** **** ***")
            print("SIGNED OUT")
            print("*** **** **** **** ***")
            
        }
    }
    
    
    func createUserData() {
        guard auth.currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        let userUID = auth.currentUser?.uid
    
        db.collection("users").document("\(userUID!)").setData([
            "uid"            : userUID ?? "",
            "firstName"     : firstName,
            "lastName"      : lastName,
            "nickName"      : nickName,
            "email"         : email,
            "dateOfBirth"   : dateOfBirth.description,
            "gender"        : gender.rawValue,
            "category"      : category
            ])
    }
}
