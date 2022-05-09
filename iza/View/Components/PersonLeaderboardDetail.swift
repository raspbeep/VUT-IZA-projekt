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
    @Binding var person: UserScore
    
    var body: some View {
        HStack {
            
            Image("crushit_logo")
                .resizable()
                .clipShape(Circle())
                .shadow(radius: 10)
                .frame(width: 60, height: 60, alignment: .leading)
                .padding(.trailing)
        
            VStack(alignment: .leading) {
                Text("\(person.user.firstName)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .padding(.bottom, 5)
                
                Text("@\(person.user.nickName)")
                    .padding(.bottom, 5)
            }
            
            Spacer()
            
            VStack {
                Spacer()
                Text("tops:")
                Spacer()
                Text("tries:")
                Spacer()
            }

            VStack {
                Spacer()
                Text("\(person.tops)")
                Spacer()
                Text("\(person.tries)")
                Spacer()
            }
        }
    }
}
