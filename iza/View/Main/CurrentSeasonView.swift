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
    
    var body: some View {
        NavigationView {
            
            switch boulderViewModel.state {
                case .success(data: let data):
                    ScrollView (.vertical, showsIndicators: true) {
                        VStack {
                            ForEach(data, content: { boulder in
                                NavigationLink(destination: Text("Hello")) {
                                    BoulderDetail(boulder: boulder.boulder, attempt: boulder.attempt)
                                }
                            })

                        }
                        
                    }
                    
                    .buttonStyle(PlainButtonStyle())
                    .navigationTitle("Current season")
                
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
    }
}

