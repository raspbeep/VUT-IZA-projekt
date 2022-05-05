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
            HStack {
                Text("Leaderboard")
                    .font(.system(size: 30, weight: .bold))
                Spacer()
                
                Button(action: {
                    Task {
                        let _ = await firestoreManager.fetchLeaderBoard(year: currentYear, month:currentMonth)
                    }
                }) {
                    Label("", systemImage: "arrow.clockwise")
                        .font(.system(size: 30, weight: .bold))
                        
                }
            }
            .padding([.top, .horizontal])
            
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
        .onAppear {
            Task {
                let _ = await firestoreManager.fetchLeaderBoard(year: currentYear, month:currentMonth)
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
