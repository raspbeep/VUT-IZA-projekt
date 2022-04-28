//
//  HomeView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI


struct LeaderboardView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                PersonLeaderboardDetail(person: User(id: "dsa", email: "dasd", firstName: "Pavel", lastName: "Kratochvil", nickName: "pavel4000", dateOfBirth: Date(), gender: "male", category: "profi"))
                
                PersonLeaderboardDetail(person: User(id: "dsa", email: "dasd", firstName: "Pavel", lastName: "Kratochvil", nickName: "pavel4000", dateOfBirth: Date(), gender: "male", category: "profi"))
                
                PersonLeaderboardDetail(person: User(id: "dsa", email: "dasd", firstName: "Pavel", lastName: "Kratochvil", nickName: "pavel4000", dateOfBirth: Date(), gender: "male", category: "profi"))
                                        
            }
        }
        .navigationTitle("Leaderboard")
        .navigationBarHidden(true)
    }
}


struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
