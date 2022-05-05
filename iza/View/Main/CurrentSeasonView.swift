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
    @State private var isEnrolled: Bool = false
    @State var firstAppear: Bool = true
    
    
    var body: some View {
        VStack {
            HStack {
                
                Text("Current Season")
                    .font(.system(size: 30, weight: .bold))
                Spacer()
                
                if isEnrolled {
                    Button(action: {
                        Task {
                            let _ = await firestoreManager.fetchSeasons(year:currentYear, month:currentMonth, userId: loginModel.auth.currentUser?.uid)
                        }
                    }) {
                        Label("", systemImage: "arrow.clockwise")
                            .font(.system(size: 30, weight: .bold))
                            
                    }
                } else {
                    Button(action: {
                        Task {
                            Task {
                                await firestoreManager.enrollUserInSeason(year: currentYear, month: currentMonth, userID: loginModel.auth.currentUser?.uid ?? "")
                                await firestoreManager.fetchSeasons(year:currentYear, month:currentMonth, userId: loginModel.auth.currentUser?.uid)
                                let res = await firestoreManager.checkEnrollment(year: currentYear, month: currentMonth, userID: loginModel.auth.currentUser?.uid ?? "")
                                if res > 0 {
                                    self.isEnrolled = true
                                } else {
                                    self.isEnrolled = false
                                }
                            }
                        }
                    }) {
                        Text("Sign up")
                            .font(.system(size: 30, weight: .semibold))
                    }
                }
                
            }
            .padding([.top, .horizontal])
            
            VStack (alignment: .leading) {
                        NavigationView {
                            VStack {
                                
                                List {
                                    ForEach($firestoreManager.attemptedBoulders) { $attemptedBoulder in
                                        ZStack {
                                            NavigationLink(destination: BoulderSheet(attemptedBoulder: $attemptedBoulder, boulderHasChanged: false)) {
                                                EmptyView()
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
            .onAppear {
                if !self.firstAppear { return }
                Task {
                    let res = await firestoreManager.checkEnrollment(year: currentYear, month: currentMonth, userID: loginModel.auth.currentUser?.uid ?? "")
                    if res > 0 {
                        self.isEnrolled = true
                        await firestoreManager.fetchSeasons(year:currentYear, month:currentMonth, userId: loginModel.auth.currentUser?.uid)
                        self.firstAppear = false
                    } else {
                        self.isEnrolled = false
                        self.firstAppear = false
                    }
                }
                
                
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct CurrentSeasonViewe_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSeasonView()
    }
}
