//
//  AttemptedBoulderViewModel.swift
//  iza
//
//  Created by Pavel Kratochvil on 03.05.2022.
//

import Foundation
import Combine


final class AttemptBoulderViewModel: ObservableObject, Identifiable {
    var id = ""
    
    private let attemptRepository = AttemptRepository()
    @Published var attemptedBoulder: AttemptedBoulder
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(attemptedBoulder: AttemptedBoulder) {
        
        self.attemptedBoulder = attemptedBoulder
        
        $attemptedBoulder
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
}
