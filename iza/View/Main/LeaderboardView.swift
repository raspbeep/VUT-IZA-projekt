//
//  HomeView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI


struct LeaderboardView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @EnvironmentObject var loginModel: LoginViewModel
    @EnvironmentObject var dateViewModel: DateViewModel
    @Environment(\.dismiss) var dismiss
    
    
    // for displaying a specific season
    @State var currentYear: String = ""
    @State var currentMonth: String = ""
    @State var showSpecificSeason: Bool = false
    
    
    @State var showHeader: Bool = true
    @State var selectedCategory: String = "profi"
    var body: some View {
        VStack {
                if showHeader {
                    HStack {
                        Text("Leaderboard")
                            .font(.system(size: 30, weight: .bold))
                        Spacer()
                        
                        Button(action: {
                            Task {
                                let _ = await firestoreManager.fetchLeaderBoard(year: currentYear, month: currentMonth)
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
                            Image(systemName: "chevron.backward")
                                .padding(.leading)
                        })
                        Spacer()
                        
                        Text("\(currentYear), \(currentMonth)")
                            .padding(.trailing)
                    }
                    
                    Picker(selection: self.$selectedCategory, label: EmptyView()) {
                            ForEach(["profi", "hobby"], id: \.self) {
                                Text($0)
                            }
                            
                    }
                    .pickerStyle(.segmented)
                    .padding(5)
                }
                
                List {
                    ForEach($firestoreManager.leaderboard) { $userScore in
                        if userScore.user.category == selectedCategory {
                            HStack {
                                PersonLeaderboardDetail(person: $userScore)
                            }
                            .padding(5)
                        }
                        
                    }
                    .refreshable {
                        Task {
                            let _ = await firestoreManager.fetchLeaderBoard(year: currentYear, month: currentMonth)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        .onAppear {
            if !self.showSpecificSeason {
                currentYear = dateViewModel.currentYear
                currentMonth = dateViewModel.currentMonth
            }
            Task {
                let _ = await firestoreManager.fetchLeaderBoard(year: currentYear, month: currentMonth)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}
