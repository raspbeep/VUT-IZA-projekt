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
    @Environment(\.dismiss) var dismiss
    
    var currentYear = "2022"
    var currentMonth = "April"
    @State var showHeader: Bool = true
    
    var body: some View {
        VStack {
                if showHeader {
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
                    .padding()
                }
            
            VStack {
                HStack {
                    if !showHeader {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Back")
                                .padding(.leading)
                        })
                        Spacer()
                        Text("Showing: \(currentYear), \(currentMonth)")
                            .padding(.trailing)
                    }
                }
                
                List {
                    ForEach($firestoreManager.leaderboard) { $userScore in
                        HStack {
                            PersonLeaderboardDetail(person: $userScore)
                        }
                        .padding(5)
                    }
                    .refreshable {
                        Task {
                            let _ = await firestoreManager.fetchLeaderBoard(year: currentYear, month:currentMonth)
                        }
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
