//
//  HomeView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI


struct HomeView: View {
    var body: some View {
        VStack {
            List(Recipe.all) { recipe in
                Text(recipe.name)
            }
        }
        .navigationTitle("Home")
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
