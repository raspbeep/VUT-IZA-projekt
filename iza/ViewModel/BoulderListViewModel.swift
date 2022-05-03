//
//  BoulderListViewModel.swift
//  iza
//
//  Created by Pavel Kratochvil on 03.05.2022.
//

import Foundation
import Combine
import SwiftUI

final class BoulderListViewModel: ObservableObject {
    @Published var boulderRepository = BoulderRepository()
    @Published var boulderViewModels: [BoulderViewModel] = []
    
    @Published var attemptRepository = AttemptRepository()
    @Published var attemptViewModels: [AttemptViewModel] = []
    
    @Published var attemptedBoulderViewModels: [AttemptBoulderViewModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        boulderRepository.$boulders
            .map { boulders in
                boulders.map(BoulderViewModel.init)
            }
            .assign(to: \.boulderViewModels, on: self)
            .store(in: &cancellables)

        attemptRepository.$attempts
            .map { attempts in
                attempts.map(AttemptViewModel.init)
            }
            .assign(to: \.attemptViewModels, on: self)
            .store(in: &cancellables)
    }
    
//    var merged: AnyPublisher<[AttemptedBoulder], Never> {
//        return Publishers.CombineLatest($attemptViewModels, $boulderViewModels)
//            .map { attempts, boulders in
//                var attemptedBoulders: [AttemptedBoulder] = []
//                ForEach(boulderViewModels) { boulderVM in
//                    if let attemptVM = attemptViewModels.first(where: { $0.attempt.boulderID == boulderVM.boulder.id }) {
//                        attemptedBoulders.append(AttemptedBoulder(id: UUID().uuidString, boulder: boulderVM, attempt: attemptVM))
//                    } else {
//
//                        attemptedBoulders.append(AttemptedBoulder(id: UUID().uuidString, boulder: boulderVM, attempt: AttemptViewModel(attempt: Attempt(boulderID: <#T##String#>, userID: <#T##String#>, tries: <#T##String#>, topped: <#T##Bool#>))))
//                    }
//                }
//            }
//            .eraseToAnyPublisher()
//    }
    
    //func getAttemptForBoulder(forBoulder: BoulderViewModel) -> AttemptViewModel {
    //    return attemptViewModels.first(where: { $0.attempt.boulderID == forBoulder.boulder.id})!
    //}
    
    
//    func connectBoulderAttempt() -> [AttemptedBoulder] {
//        var attemptedBoulders: [AttemptedBoulder] = []
//        ForEach(boulderViewModels) { boulderVM in
//            if let attemptVM = attemptViewModels.first(where: { $0.attempt.boulderID == boulderVM.boulder.id }) {
//                attemptedBoulders.append(AttemptedBoulder(id: UUID().uuidString, boulder: boulderVM, attempt: attemptVM))
//            } else {
//
//            }
//        }
//    }
    
    func update() {
        
    }
}


