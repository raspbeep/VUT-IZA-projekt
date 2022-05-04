//
//  NewRecipeView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI
import Firebase

struct CurrentSeasonView: View {
    @StateObject var firestoreManager: FirestoreManager = FirestoreManager()
    @EnvironmentObject var loginModel: LoginViewModel
    private let currentYear = "2022"
    private let currentMonth = "April"
    @State private var showingDetail: Bool = false
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Current Season")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.horizontal)
                Spacer()
            }
            
            VStack (alignment: .leading) {
                        NavigationView {
                            VStack {
                                Button(action: {
                                    Task{
                                        await firestoreManager.fetchSeasons(year:currentYear, month:currentMonth, userId: loginModel.auth.currentUser?.uid)
                                    }
                                    
                                    print(firestoreManager.attemptedBoulders)
                                }) {
                                    Text("load")
                                }
                                Button("Enroll") {
                                    Task {
                                        await firestoreManager.enrollUserInSeason(year: currentYear, month: currentMonth, userID: loginModel.auth.currentUser?.uid ?? "")
                                    }
                                }
                                List {
                                    ForEach($firestoreManager.attemptedBoulders) { $attemptedBoulder in
                                        ZStack {
                                            NavigationLink(destination: BoulderSheet(attemptedBoulder: $attemptedBoulder, boulderHasChanged: false)) {
                                                EmptyView()
                                            }
                                            .onTapGesture {
                                                showingDetail = true
                                            }
                                            
                                            .padding(0)
                                            .opacity(0.0)
                                            .buttonStyle(PlainButtonStyle())
                                                
                                            HStack {
                                                BoulderView(attemptedBoulder: $attemptedBoulder)
                                            }
                                        }
                                    }
                                }
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                                .listStyle(PlainListStyle())
                            }
                    }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .padding(.top, 10)
        .onAppear {
            UITableView.appearance().separatorColor = .clear
        }
        
    }
}

struct CurrentSeasonViewe_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSeasonView()
    }
}
