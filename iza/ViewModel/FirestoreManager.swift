//
//  FirestoreManager.swift
//  iza
//
//  Created by Pavel Kratochvil on 03.05.2022.
//

import Foundation
import Firebase
import FirebaseFirestore


final class FirestoreManager: ObservableObject {
    private let bouldersQuery: Query = Firestore.firestore().collection("boulders")
    private let attemptsQuery: Query = Firestore.firestore().collection("attempts")
    private let seasonsQuery : Query = Firestore.firestore().collection("seasons")
    private let usersQuery : Query = Firestore.firestore().collection("users")
    
    @Published var attempts: [Attempt] = []
    @Published var boulders: [Boulder] = []
    @Published var seasons: [Seasons] = []
    @Published var attemptedBoulders: [AttemptedBoulder] = []
    @Published var leaderboard: [UserScore] = []
    @Published var users: [User] = []
    
    private var boulderIDs: [String] = []
    private var userIDs: [String] = []
    
    private var fetchingBoulders: Bool = false
    private var fetchingAttempts: Bool = false
    
    // gets attempts from db and stores them in boulders: [Attempt]
    func fetchAttempts(boulderID: String?, userID: String?, forBoulderIDs: [String]?) async throws {
        DispatchQueue.main.async {
            self.fetchingAttempts = true
        }
        var filteredQuery = attemptsQuery
        
        if let boulderID = boulderID {
          filteredQuery = filteredQuery.whereField("boulderID", isEqualTo: boulderID)
        }
        
        if let userID = userID {
          filteredQuery = filteredQuery.whereField("userID", isEqualTo: userID)
        }
        
        if let forBoulderIDs = forBoulderIDs {
          filteredQuery = filteredQuery.whereField("boulderID", in: forBoulderIDs)
        }
        
        
        let snapshot = try await Firestore.firestore().collection("attempts").getDocuments()
        
        DispatchQueue.main.async {
            self.attempts = snapshot.documents.compactMap {
                try? $0.data(as: Attempt.self)
            }
            self.fetchingAttempts = false
        }
    }
    
    // gets boulders from db and stores them in boulders: [Boulder]
    func fetchBoulders(year: String?, month: String?) async throws {
        DispatchQueue.main.async {
            self.fetchingBoulders = true
        }
        var filteredQuery = bouldersQuery

        if let year = year {
          filteredQuery = filteredQuery.whereField("year", isEqualTo: year)
        }

        if let month = month {
          filteredQuery = filteredQuery.whereField("month", isEqualTo: month)
        }

        let snapshot = try await filteredQuery.getDocuments()
            
        DispatchQueue.main.async {
            self.boulders = snapshot.documents.compactMap {
                try? $0.data(as: Boulder.self)
            }
            self.fetchingBoulders = false
        }
    }
    
    // gets users from db and stores them in users: [User]
    func fetchUsers(forIDs: [String]?) async throws {
        
        var filteredQuery = usersQuery

        if let forIDs = forIDs {
          filteredQuery = filteredQuery.whereField("userID", in: forIDs)
        }

        let snapshot = try await filteredQuery.getDocuments()
            
        DispatchQueue.main.async {
            self.users = snapshot.documents.compactMap {
                try? $0.data(as: User.self)
            }
        }
    }
    
    func fetchSeasons() async throws {
        let snapshot = try await seasonsQuery.getDocuments()
        DispatchQueue.main.async {
            self.seasons = snapshot.documents.compactMap {
                try? $0.data(as: Seasons.self)
            }
        }
    }
    
    
    func getSeason(year: String?, month: String?, userID: String?) async {
       
        Task {
            DispatchQueue.main.async {
                self.fetchingAttempts = true
                self.fetchingBoulders = true
            }
            try await fetchAttempts(boulderID: nil, userID: userID, forBoulderIDs: nil)
            try await fetchBoulders(year: year, month: month)
            DispatchQueue.main.async {
                self.compile(boulders: self.boulders, attempts: self.attempts)
            }
        }
    }
    
    func compile(boulders: [Boulder], attempts: [Attempt]) {
        DispatchQueue.main.async {
            self.attemptedBoulders = []
        }
        for boulder in boulders {
            guard let attempt = getAttemptForBoulder(boulder: boulder) else { return }
            DispatchQueue.main.async {
                self.attemptedBoulders.append(AttemptedBoulder(id: UUID().uuidString, boulder: boulder, attempt: attempt))
            }
            
        
        }
    }
    
    func getAttemptForBoulder(boulder: Boulder) -> Attempt? {
        for attempt in attempts {
            if attempt.boulderID == boulder.id {
                return attempt
            }
        }
        
        return nil
    }
    
    func changeAttemptedBoulder(attemptedBoulder: AttemptedBoulder) async throws {
        do {
            if let docID = attemptedBoulder.attempt.id {
                try Firestore.firestore().collection("attempts").document(docID).setData(from: attemptedBoulder.attempt)
            }
        } catch {
            print("smth")
        }
    }
    
    func fetchLeaderBoard(year: String?, month: String?) async throws {
        // fetch boulders for current season
        try await fetchBoulders(year: year, month: month)
        
        self.boulderIDs = []
        for boulder in self.boulders {
            self.boulderIDs.append(boulder.id ?? "")
        }
        
        try await fetchAttempts(boulderID: nil, userID: nil, forBoulderIDs: self.boulderIDs)
        
        self.userIDs = []
        for attempt in self.attempts {
            self.userIDs.append(attempt.userID)
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}
