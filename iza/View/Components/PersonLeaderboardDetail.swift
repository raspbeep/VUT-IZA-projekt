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
                            .frame(width: 80, height: 80, alignment: .center)
                    
                        VStack(alignment: .leading) {
                            Text("\(person.user.firstName)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .padding(.bottom, 5)
                            
                            Text("@\(person.user.nickName)")
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
                            Text("\(person.tops)")
                            Spacer()
                            Text("\(person.tries)")
                            Spacer()
                        }
                    }
//                .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}


struct PersonLeaderBoard_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
