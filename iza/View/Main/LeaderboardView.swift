//
//  HomeView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI


struct LeaderboardView: View {
    @StateObject var firestoreManager: FirestoreManager = FirestoreManager()
    @EnvironmentObject var loginModel: LoginViewModel
    private let currentYear = "2022"
    private let currentMonth = "April"
    @State private var showingDetail: Bool = true
    
    
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    let _ = await firestoreManager.fetchLeaderBoard(year: currentYear, month:currentMonth)
                    print(firestoreManager.leaderboard)
                }
            }) {
                Text("load")
            }
            VStack {
                List {
                    ForEach($firestoreManager.leaderboard) { $userScore in
                        HStack {
                            PersonLeaderboardDetail(person: $userScore)
                        }
                        .padding()
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
