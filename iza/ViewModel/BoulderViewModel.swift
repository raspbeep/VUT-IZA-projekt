//
//  BoulderViewModel.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation


@MainActor
class BoulderViewModel: ObservableObject {
    
    enum State {
        case na
        case loading
        case success(data: [AttemptedBoulder])
        case failed(error: Error)
    }
    
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    
    private let boulderService: BoulderService
    private let attemptService: AttemptService
    
    init(boulderService: BoulderService, attemptService: AttemptService) {
        self.boulderService = boulderService
        self.attemptService = attemptService
    }
    
    
    func getBoulder() async {
        self.state = .na
        self.hasError = false
        
        do {
            let boulders = try await boulderService.fetchBoulders()
            let attempts = try await attemptService.fetchAttempts()
            
            var listOfBouldersWithAttempts = [AttemptedBoulder]()
            
            for boulder in boulders {
                if let attempt = attempts.first(where: {$0.boulderID == boulder.id}) {
                    listOfBouldersWithAttempts.append(AttemptedBoulder(id: UUID(), boulder: boulder, attempt: attempt))
                } else {
                    let attempt = Attempt(id: UUID().uuidString, boulderID: boulder.id, userID: "e75R3rXwvkaGmDQ3ZZ9WZluWTq62", tries: "0", topped: false)
                    listOfBouldersWithAttempts.append(AttemptedBoulder(id: UUID(), boulder: boulder, attempt: attempt))
                }
            }
            
            self.state = .success(data: listOfBouldersWithAttempts)
            
        } catch {
            self.state = .failed(error: error)
            self.hasError = true 
        }
    }
}
