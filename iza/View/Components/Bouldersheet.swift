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
    @ObservedObject var boulderViewModel : BoulderViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
            Text("\(boulderToShow.boulder.number)")
            
            Button("Close this") {
                
                guard var attemptToChange = boulderViewModel.listOfBouldersWithAttempts.first(where: {$0.attempt.boulderID == boulderToShow.boulder.id}) else { return }
                DispatchQueue.main.async {
                    boulderViewModel.listOfBouldersWithAttempts = boulderViewModel.listOfBouldersWithAttempts
                        .map { attemptedBoulder -> AttemptedBoulder in
                            if attemptedBoulder.attempt.boulderID == boulderToShow.boulder.id {
                                var incremented = attemptedBoulder
                                incremented.attempt.tries = String(Int(attemptedBoulder.attempt.tries)! + 1)
                                return incremented
                            }
                            return attemptedBoulder
                        }
                }
                dismiss()
            }
        }
    }
}
