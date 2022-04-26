//
//  SignUpView.swift
//  vut-iza
//
//  Created by Pavel Kratochvil on 22.04.2022.
//

import SwiftUI

struct SignUpView: View {
    
    @State var email = ""
    @State var password = ""
    
    
    @State var gender = "male"
    
    let genders = ["male", "female"]
    
    @EnvironmentObject var loginViewModel: LoginModel

    var body: some View {
        VStack {
            //Form {
                //Section {
                    TextField("Firts name", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
            
                        .cornerRadius(3.0)
                //}
                //Section {
                    TextField("Last Name", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .cornerRadius(3.0)
                //}
                        //NavigationView {
                            
                //Section {
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }
                //}
                
                //Section {
                    TextField("Age", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .cornerRadius(5.0)
                //}
                
                //Section {
                    TextField("Email", text: $email)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(5.0)
                //}
                
                //Section {
                    SecureField("Password", text: $password)
                        .cornerRadius(5.0)
                //}
            
                
            //Section {
                    Button(action: {
                        // insert combine controls
                        loginViewModel.signUp(email: email, password: password)
                    }){
                        HStack {
                           Spacer()
                           Text("Save")
                           Spacer()
                       }
                    }
            //}
        //}
                
        
        }
        .padding()
        .navigationTitle("Create account")
    }
}
    


struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
