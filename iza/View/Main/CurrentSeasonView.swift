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
    @State private var showingDetail: Bool = true
    
    var body: some View {
        VStack {
            if showingDetail {
                
            } else {
                HStack {
                    Text("Current Season")
                        .font(.system(size: 30, weight: .bold))
                        .padding(.horizontal)
                    Spacer()
                }
            }
            
            
            Button(action: {
                Task {
                    await firestoreManager.getSeason(year: currentYear, month: currentMonth, userID: loginModel.auth.currentUser?.uid)
                    print(firestoreManager.attemptedBoulders)
                }
            }) {
                Text("load")
            }
            
            VStack (alignment: .leading) {
                        NavigationView {
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
        .navigationTitle("")
        .navigationBarHidden(true)
        .padding(.top, 10)
        .onAppear {
            UITableView.appearance().separatorColor = .clear
                
            Task {
                
                await firestoreManager.getSeason(year: currentYear, month: currentMonth, userID: loginModel.auth.currentUser?.uid)
                print(firestoreManager.attemptedBoulders)
            }
        }
        
    }
}

struct CurrentSeasonViewe_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSeasonView()
    }
}
