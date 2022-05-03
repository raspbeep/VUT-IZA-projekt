//
//  BoulderViewModel.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation


//@MainActor
class SeasonViewModel: ObservableObject {
    
    enum State {
        case na
        case loading
        case success(data: Season)
        case failed(error: Error)
    }
    
    var forYear: String;
    var forMonth: String;
    
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    @Published var userID: String = ""
    @Published var listOfBouldersWithAttempts = [AttemptedBoulder]()
    
    let seasonService: SeasonService = SeasonService()
    
    
    func getSeasons() async {
        self.state = .na
        self.hasError = false
        
        do {
            let seasons = try await seasonService.fetchSeasons()
            
            
            DispatchQueue.main.async {
                
            }
            
        } catch {
            DispatchQueue.main.async {
                self.state = .failed(error: error)
                self.hasError = true
            }
        }
    }
}
