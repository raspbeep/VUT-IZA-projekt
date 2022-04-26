//
//  NewRecipeView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI


struct CurrentSeasonView: View {
    var body: some View {
            VStack {
                Text("New Recipe")
            }
            .navigationTitle("Current season")
    }
}

struct CurrentSeasonViewe_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSeasonView()
    }
}
