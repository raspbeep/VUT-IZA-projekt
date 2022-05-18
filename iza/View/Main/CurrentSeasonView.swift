//
//  NewRecipeView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI
import Firebase

struct CurrentSeasonView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @EnvironmentObject var loginModel: LoginViewModel
    @EnvironmentObject var dateViewModel: DateViewModel

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
                            let _ = await firestoreManager.fetchSeasons(year: dateViewModel.currentYear, month: dateViewModel.currentMonth, userId: loginModel.auth.currentUser?.uid)
                        }
                    }) {
                        Label("", systemImage: "arrow.clockwise")
                            .font(.system(size: 30, weight: .bold))
                    }
                } else {
                    Button(action: {
                        Task {
                            Task {
                                await firestoreManager.enrollUserInSeason(year: dateViewModel.currentYear, month: dateViewModel.currentMonth, userID: loginModel.auth.currentUser?.uid ?? "")
                                await firestoreManager.fetchSeasons(year: dateViewModel.currentYear, month: dateViewModel.currentMonth, userId: loginModel.auth.currentUser?.uid)
                                let res = await firestoreManager.checkEnrollment(year: dateViewModel.currentYear, month: dateViewModel.currentMonth, userID: loginModel.auth.currentUser?.uid ?? "")
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
                if !isEnrolled {
                    VStack {
                        Text("You are not enrolled in the current season. Sign up to record your performance!")
                            .padding()
                    }
                }
                NavigationView {
                    VStack {
                        List {
                            ForEach($firestoreManager.attemptedBoulders) { $attemptedBoulder in
                                ZStack {
                                    NavigationLink(destination: BoulderDetailView(attemptedBoulder: $attemptedBoulder, boulderHasChanged: false)) {
                                        EmptyView()
                                    }
                                    
                                    .padding(0)
                                    .opacity(0.0)
                                    .buttonStyle(PlainButtonStyle())
                                        
                                    HStack {
                                        BoulderListItem(attemptedBoulder: $attemptedBoulder)
                                    }
                                }
                            }
                        }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .listStyle(PlainListStyle())
                    }
                }
            }
        }
        .onAppear {
            if !self.firstAppear { return }
            Task {
                let res = await firestoreManager.checkEnrollment(year: dateViewModel.currentYear, month: dateViewModel.currentMonth, userID: loginModel.auth.currentUser?.uid ?? "")
                if res > 0 {
                    self.isEnrolled = true
                    await firestoreManager.fetchSeasons(year: dateViewModel.currentYear, month: dateViewModel.currentMonth, userId: loginModel.auth.currentUser?.uid)
                    self.firstAppear = false
                } else {
                    self.isEnrolled = false
                    self.firstAppear = false
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
