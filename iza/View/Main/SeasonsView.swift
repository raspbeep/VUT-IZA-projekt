//
//  CategoriesView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI


struct SeasonsView: View {
    var body: some View {
        VStack {
            HStack {
                Text("All Challenges")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.horizontal)
                Spacer()
            }
            Spacer()
                Text("All Challenges")
            Spacer()
        }
        .padding(.top, 20)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}


struct SeasonsView_Previews: PreviewProvider {
    static var previews: some View {
        SeasonsView()
    }
}
