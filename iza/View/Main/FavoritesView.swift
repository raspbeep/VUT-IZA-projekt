//
//  FavoritesView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI


struct FavoritesView: View {
    var body: some View {
        VStack {
            Text("My favorites")
        }
        .navigationTitle("Favorites")
    }
}


struct Favorites_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
