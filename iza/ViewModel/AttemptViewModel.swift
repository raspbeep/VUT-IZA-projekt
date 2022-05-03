//
//  BoulderViewModel.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation
import Combine


final class AttemptViewModel: ObservableObject, Identifiable {
    var id = ""
    
    private let attemptRepository = AttemptRepository()
    @Published var attempt: Attempt
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(attempt: Attempt) {
        self.attempt = attempt
        $attempt
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    
    func add(_ attempt: Attempt) {
        attemptRepository.add(attempt)
    }
}
