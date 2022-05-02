//
//  Bouldersheet.swift
//  iza
//
//  Created by Pavel Kratochvil on 29.04.2022.
//

import Foundation
import SwiftUI
import Combine


struct BoulderSheet: View {
    
    var boulderToShow: AttemptedBoulder
    //@ObservedObject var boulderViewModel: BoulderViewModel
    @Environment(\.dismiss) var dismiss
    
    var numberOfTries: String
    
    init(boulderToShow: AttemptedBoulder) {
        self.boulderToShow = boulderToShow
        numberOfTries = boulderToShow.attempt.tries
    }
    
    var body: some View {
        VStack {
            
            
            
            
            Spacer()
            
            Button(action: {
                dismiss()
            }, label: {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(8.0)
            })
            
            
                
//                guard var attemptToChange = boulderViewModel.listOfBouldersWithAttempts.first(where: {$0.attempt.boulderID == boulderToShow.boulder.id}) else { return }
//                DispatchQueue.main.async {
//                    boulderViewModel.listOfBouldersWithAttempts = boulderViewModel.listOfBouldersWithAttempts
//                        .map { attemptedBoulder -> AttemptedBoulder in
//                            if attemptedBoulder.attempt.boulderID == boulderToShow.boulder.id {
//                                var incremented = attemptedBoulder
//                                incremented.attempt.tries = String(Int(attemptedBoulder.attempt.tries)! + 1)
//                                return incremented
//                            }
//                            return attemptedBoulder
//                        }
//                }
                
            
        }
    }
}

struct BoulderSheet_Previews: PreviewProvider {
    static var previews: some View {
        BoulderSheet(boulderToShow: AttemptedBoulder(id: UUID(),
                                          boulder:
                                             Boulder(id: "15616", year: "2022", month: "January", number: "15", sector: "Nose", color: "red", grade: "8a+"),
                                          attempt:
                                             Attempt(id: "smth", boulderID: "smth", userID: "smth", tries: "2", topped: false)))
    }
}
