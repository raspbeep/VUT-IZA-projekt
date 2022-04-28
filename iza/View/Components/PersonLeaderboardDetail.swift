//
//  PersonLeaderboardDetail.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation
import SwiftUI


struct PersonLeaderboardDetail: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    var person: User
    
    
//    struct User: Identifiable {
//        let id: String
//        let email: String
//        let firstName: String
//        let lastName: String
//        let nickName: String
//        let dateOfBirth: Date
//        let gender: String
//        let category: climbingCategory.RawValue
//    }
    
    
    
    var body: some View {
        ZStack(alignment: .leading) {
                    Color.secondary
                    HStack {
                        
                        Image("crushit_logo")
                            .resizable()
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.yellow, lineWidth: 2))
                            .frame(width: 80, height: 80, alignment: .center)
                            .padding(.trailing)
                    
                        VStack(alignment: .leading) {
                            Text("\(person.firstName)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .padding(.bottom, 5)
                            
                            Text("@\(person.nickName)")
                                .padding(.bottom, 5)
                        }
                        .padding(.horizontal)
                        
                        VStack {
                            Spacer()
                            Text("tops:")
                            Spacer()
                            Text("tries:")
                            Spacer()
                        }
                        
                        
                        VStack {
                            Spacer()
                            Text("\(45)")
                            Spacer()
                            Text("\(12)")
                            Spacer()
                        }
                    }
                    .padding()
                }
            
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal)
    }
}


struct PersonLeaderboardDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrollView {
                PersonLeaderboardDetail(person: User(id: "dsa", email: "dasd", firstName: "Pavel", lastName: "Kratochvil", nickName: "pavel4000", dateOfBirth: Date(), gender: "male", category: "profi"))
                
                PersonLeaderboardDetail(person: User(id: "dsa", email: "dasd", firstName: "Pavel", lastName: "Kratochvil", nickName: "pavel4000", dateOfBirth: Date(), gender: "male", category: "profi"))
                
                PersonLeaderboardDetail(person: User(id: "dsa", email: "dasd", firstName: "Pavel", lastName: "Kratochvil", nickName: "pavel4000", dateOfBirth: Date(), gender: "male", category: "profi"))
                                        
            }
        }
        .environmentObject(LoginViewModel())
    }
}
