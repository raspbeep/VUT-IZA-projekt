//
//  FavoritesView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI


struct FavoritesView: View {
    @EnvironmentObject var loginModel: LoginViewModel
    @StateObject var firestoreManager: FirestoreManager = FirestoreManager()
    
    @State var boulders = [AttemptedBoulder]()
    
    var body: some View {
        VStack {
            HStack {
                Text("My Performance")
                    .font(.system(size: 30, weight: .bold))
                    
                Spacer()
            }
            VStack {
                List {
                    ForEach(self.$boulders) { $attemptedBoulder in
                        HStack {
                            BoulderListItem(attemptedBoulder: $attemptedBoulder)
                        }
                    }
                .listStyle(PlainListStyle())
            }
            .padding()
            }
            .onAppear {
                Task {
                    let boulders = await firestoreManager.getSeason(year: nil, month: nil, userID: loginModel.auth.currentUser?.uid)
                    DispatchQueue.main.async {
                        self.boulders = boulders
                    }
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }

}

//struct Favorites_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoritesView()
//    }
//}
