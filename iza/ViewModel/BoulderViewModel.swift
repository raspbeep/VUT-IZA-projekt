//
//  BoulderViewModel.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation
import Combine


final class BoulderViewModel: ObservableObject, Identifiable {
    var id = ""
    
    private let boulderRepository = BoulderRepository()
    @Published var boulder: Boulder
    
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(boulder: Boulder) {
        self.boulder = boulder
        $boulder
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    

}
