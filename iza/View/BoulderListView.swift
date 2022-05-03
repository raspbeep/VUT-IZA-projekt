//
//  SeasonListView.swift
//  iza
//
//  Created by Pavel Kratochvil on 03.05.2022.
//

import Foundation
import SwiftUI


struct BoulderListView: View {
    @ObservedObject var boulderListViewModel: BoulderListViewModel
    
    @State private var showingSheet = false
    
    
    func connectBoulderToAttempt() {
        
    }
    
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(boulderListViewModel.boulderViewModels) { boulderVM in
                    var attemptVM: AttemptViewModel = boulderListViewModel.getAttemptForBoulder(forBoulder: boulderVM)
                    BoulderView(boulderViewModel: boulderVM, attemptViewModel: attemptVM)
                }
            }
        }
        .onAppear {
            connectBoulderToAttempt()
        }
    }
}




struct BoulderListView_Previews: PreviewProvider {
    static var previews: some View {
        BoulderListView(boulderListViewModel: BoulderListViewModel())
    }
}
