//
//  CategoriesView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI

struct PreviousSeasonsView: View {
    @StateObject var firestoreManager: FirestoreManager = FirestoreManager()
    @State var showingDetail: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("All Challenges")
                    .font(.system(size: 30, weight: .bold))
                    
                Spacer()
                
                Button(action: {
                    Task {
                        let _ = await firestoreManager.fetchAllSeasons()
                    }
                }) {
                    Label("", systemImage: "arrow.clockwise")
                        .font(.system(size: 30, weight: .bold))
                }
            }
            .padding()

            VStack {
                NavigationView {
                    VStack {
                        List {
                            ForEach($firestoreManager.seasons) { $season in
                                NavigationLink(destination: LeaderboardView(currentYear: season.year, currentMonth: season.month, showHeader: false)) {
                                    HStack {
                                        Text(season.year)
                                        Text(season.month)
                                    }
                                    .padding(5)
                                }
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .refreshable {
                            let _ = await firestoreManager.fetchAllSeasons()
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                let _ = await firestoreManager.fetchAllSeasons()
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}
