//
//  BoulderViewModel.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation


//@MainActor
class BoulderViewModel: ObservableObject {
    
    enum State {
        case na
        case loading
        case success(data: [AttemptedBoulder])
        case failed(error: Error)
    }
    
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    @Published var userID: String = ""
    @Published var listOfBouldersWithAttempts = [AttemptedBoulder]()
    
    let boulderService: BoulderService = BoulderService()
    let attemptService: AttemptService = AttemptService()
    
    
    func getBoulder() async {
        self.state = .na
        self.hasError = false
        
        do {
            let boulders = try await boulderService.fetchBoulders()
            let attempts = try await attemptService.fetchAttempts(forUser: userID)
            
            DispatchQueue.main.async {
                self.listOfBouldersWithAttempts = [AttemptedBoulder]()
                for boulder in boulders {
                    if let attempt = attempts.first(where: {$0.boulderID == boulder.id}) {
                        self.listOfBouldersWithAttempts.append(AttemptedBoulder(id: UUID(), boulder: boulder, attempt: attempt))
                    } else {
                        let attempt = Attempt(id: UUID().uuidString, boulderID: boulder.id, userID: self.userID, tries: "0", topped: false)
                        self.listOfBouldersWithAttempts.append(AttemptedBoulder(id: UUID(), boulder: boulder, attempt: attempt))
                    }
                }
                self.state = .success(data: self.listOfBouldersWithAttempts)
            }
            
        } catch {
            DispatchQueue.main.async {
                self.state = .failed(error: error)
                self.hasError = true
            }
        }
    }
}
