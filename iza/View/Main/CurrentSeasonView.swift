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
    @EnvironmentObject var boulderViewModel: BoulderViewModel
    
    @State private var showingSheet: Bool = false
    
    var body: some View {
        //NavigationView {
        VStack {
            switch boulderViewModel.state {
                case .success(data: let data):
                VStack (alignment: .leading) {
                        Text("Current Season")
                            .padding()
                            .font(.system(size: 30, weight: .semibold))
                        ScrollView (.vertical, showsIndicators: true) {
                            VStack {
                                ForEach(data, content: { boulder in
                                    
                                    Button(action: {
                                        showingSheet.toggle()
                                    }, label: {
                                        BoulderDetail(boulder: boulder.boulder, attempt: boulder.attempt)
                                    })
                                        
                                    .sheet(isPresented: $showingSheet) {BoulderSheet(boulderToShow: boulder, boulderViewModel: boulderViewModel)}
                                })
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .navigationTitle("Current season")
                    }
                
                case .loading:
                    VStack {
                        Text("loading")
                        ProgressView()
                    }
                    
                default:
                    ProgressView()
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .padding(.top, 10)
        .task {
            boulderViewModel.userID = loginModel.auth.currentUser?.uid ?? ""
            await boulderViewModel.getBoulder()
        }.alert("Error", isPresented: $boulderViewModel.hasError, presenting: boulderViewModel.state) { detail in
            Button("Retry") {
                Task {
                    await boulderViewModel.getBoulder()
                }
            }
        } message: { detail in
            if case let .failed(error) = detail {
                Text(error.localizedDescription)
            }
        }
        
        
    }
}

struct CurrentSeasonViewe_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSeasonView()
            .environmentObject(FirestoreManager())
            .environmentObject(BoulderViewModel())
    }
}

