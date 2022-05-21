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

// class for handling registration and logging in
class LoginViewModel: ObservableObject {
    @Published var errorMessage: String?
    
    @Published var currentUser = User(id: "", uid: "", email: "", firstName: "", lastName: "", nickName: "", dateOfBirth: "", gender: "", category: "")
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
    
    // combine variables used for input validation
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
    
    var currentUserID: String {
        return self.auth.currentUser?.uid ?? ""
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
    
    func fetchCurrentUser() async {
        guard let user = await self.getCurrentUser() else { return }
        DispatchQueue.main.async {
            self.currentUser = user
        }
        
    }
    
    func getCurrentUser() async -> User? {
        let query = Firestore.firestore().collection("users").whereField("uid", isEqualTo: self.currentUserID)
        do {
            let snapshot = try await query.getDocuments()
            let result =  snapshot.documents.compactMap {try? $0.data(as: User.self)}
            return result[0]
        } catch {
            return nil
        }
    }
    
    func signIn() async {
        do {
            // attempts to sign in
            let _ = try await auth.signIn(withEmail: email, password: password)
                    
            // writes the result into a published variable
            DispatchQueue.main.async {
                self.signedIn = true
            }
            
        } catch {
            // in case logging in failed, print error description to console
            // TODO: inform user about the problem
            print("There was an error signing in: \(error.localizedDescription.description)")
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func signUp() async {
        do {
            // attempts to sign up the user using the provided information in registration form
            let _ = try await auth.createUser(withEmail: email, password: password)
                        
            DispatchQueue.main.async {
                self.signedIn = true
            }
            
            // write personal information into database
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
            // signs the user out and resets registration form
            try? auth.signOut()
            self.signedIn = false
            self.password = ""
            self.passwordAgain = ""
            self.firstName = ""
            self.lastName = ""
            self.nickName = ""
        }
    }
    
    // creates a document in collection users
    // binded to user id provided by auth module in attribute of document
    func createUserData() {
        guard auth.currentUser != nil else {
            return
        }
        
        let db = Firestore.firestore()
        let userUID = auth.currentUser?.uid
    
        db.collection("users").document("\(userUID!)").setData([
            "uid"           : userUID ?? "",
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
