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
    
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: true) {
                ForEach(firestoreManager.listOfBoulders, content: { boulder in
                    BoulderDetail(boulder: boulder)
                })
            }
            .padding(.top, 10)
            .navigationBarHidden(true)
        }
    }
}

struct CurrentSeasonViewe_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSeasonView()
            .environmentObject(FirestoreManager())
    }
}
