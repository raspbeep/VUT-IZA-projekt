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
    @Published var seasons: [Season] = []
    @Published var attemptedBoulders: [AttemptedBoulder] = []
    @Published var leaderboard: [UserScore] = []
    @Published var users: [User] = []
    
    private var boulderIDs: [String] = []
    private var userIDs: [String] = []
    
    private var fetchingBoulders: Bool = false
    private var fetchingAttempts: Bool = false
    
    
    // gets attempts from db and stores them in boulders: [Attempt]
    func fetchAttempts(boulderID: String?, userID: String?, forBoulderIDs: [String]?) async throws {
        let attempts = await getAttempts(boulderID: boulderID, userID: userID, forBoulderIDs: forBoulderIDs)
        DispatchQueue.main.async {
            self.attempts = attempts
        }
    }
    
    func getAttempts(boulderID: String?, userID: String?, forBoulderIDs: [String]?) async -> [Attempt] {
        var newQuery: Query = Firestore.firestore().collection("attempts")
        
        if let boulderID = boulderID {
            newQuery = newQuery.whereField("boulderID", isEqualTo: boulderID)
        }
        
        if let userID = userID {
            newQuery = newQuery.whereField("userID", isEqualTo: userID)
        }
        
        if let forBoulderIDs = forBoulderIDs {
            newQuery = newQuery.whereField("boulderID", in: forBoulderIDs)
        }
        
        do {
            let snapshot = try await newQuery.getDocuments()
            return snapshot.documents.compactMap {try? $0.data(as: Attempt.self)}
        } catch {
            print("nope")
            return []
        }
    }
    
    
    func getBoulders(year: String?, month: String?) async -> [Boulder] {
        var newQuery: Query = Firestore.firestore().collection("boulders")
        
        if let year = year {
          newQuery = newQuery.whereField("year", isEqualTo: year)
        }

        if let month = month {
          newQuery = newQuery.whereField("month", isEqualTo: month)
        }
        
        do {
            let snapshot = try await newQuery.getDocuments()
            return snapshot.documents.compactMap {try? $0.data(as: Boulder.self)}
        } catch {
            print("nope")
            return []
        }
    }
    
    // gets users from db
    func getUsers(forIDs: [String]?) async -> [User] {
        let filteredQuery = Firestore.firestore().collection("users")
        var newQuery: Query = filteredQuery
        
        if let forIDs = forIDs {
            newQuery = newQuery.whereField("uid", in: forIDs)
        }
            
        do {
            let snapshot = try await newQuery.getDocuments()
            return snapshot.documents.compactMap {try? $0.data(as: User.self)}
        } catch {
            return []
        }
    }
    
    func fetchSeasons(year: String, month: String, userId: String?) async {
        let season = await getSeason(year: year, month: month, userID: userId)
        
        DispatchQueue.main.async {
            self.attemptedBoulders = season
        }
    }
    
    
    func getSeason(year: String?, month: String?, userID: String?) async -> [AttemptedBoulder] {
        let b = await getBoulders(year: year, month: month)
        let a = await getAttempts(boulderID: nil, userID: userID, forBoulderIDs: nil)
        
        var compiled = compile(boulders: b, attempts: a)
        compiled.sort(by: { Int($0.boulder.number)! < Int($1.boulder.number)! })
        return compiled
    }
    
    func compile(boulders: [Boulder], attempts: [Attempt]) -> [AttemptedBoulder] {
        var returnVal = [AttemptedBoulder]()
        for boulder in boulders {
            if let attempt = getAttemptForBoulder(boulder: boulder, attempts: attempts) {
                returnVal.append(AttemptedBoulder(id: UUID().uuidString, boulder: boulder, attempt: attempt))
            }
        }
        return returnVal
    }
    
    func getAttemptForBoulder(boulder: Boulder, attempts: [Attempt]) -> Attempt? {
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
    
    func fetchLeaderBoard(year: String?, month: String?) async {
        let leaderboard = await getLeaderBoard(year: year, month: month)
        
        DispatchQueue.main.async {
            self.leaderboard = leaderboard
        }
    }
    
    func getLeaderBoard(year: String?, month: String?) async -> [UserScore] {
        
        let listOfBoulders = await getBoulders(year: year, month: month)
        
        var boulderIDs = [String]()
        for boulder in listOfBoulders {
            boulderIDs.append(boulder.id ?? "")
        }
        
        let listOfAttempts = await getAttempts(boulderID: nil, userID: nil, forBoulderIDs: boulderIDs)

        var userIDs = [String]()
        for attempt in listOfAttempts {
            if !userIDs.contains(where: {attempt.userID == $0}) {
                userIDs.append(attempt.userID)
            }
        }
        
        if userIDs == [] {
            return []
        }
        
        let users = await getUsers(forIDs: userIDs)
        
        var userScores = [UserScore]()
        
        for user in users {
            var userScore = UserScore(id: UUID().uuidString, user: user, tops: "0", tries: "0")
            for attempt in listOfAttempts {
                if attempt.userID == user.uid {
                    if attempt.topped {
                        userScore.tops = String(Int(userScore.tops)! + 1)
                        userScore.tries = String(Int(userScore.tries)! + Int(attempt.tries)!)
                    }
                }
            }
            userScores.append(userScore)
        }
        
        userScores.sort(by: { Int($0.tries)! < Int($1.tries)! })
        userScores.sort(by: { Int($0.tops)! > Int($1.tops)! })
        
        return userScores
        
    }

    func checkEnrollment(year: String, month: String, userID: String) async  -> Int {
        let boulders = await getBoulders(year: year, month: month)
        var boulderIDs = [String]()
        for boulder in boulders {
            boulderIDs.append(boulder.id ?? "")
        }
        let attempts = await getAttempts(boulderID: nil, userID: userID, forBoulderIDs: boulderIDs)
        return attempts.count
    }
    
    func enrollUserInSeason(year: String, month: String, userID: String) async {
        if await checkEnrollment(year: year, month: month, userID: userID)  > 0 { return }
        
        let boulders = await getBoulders(year: year, month: month)
        for boulder in boulders {
            do {
                let _ = try await Firestore.firestore().collection("attempts").addDocument(data: [
                    "boulderID"  : boulder.id!,
                    "userID"    : userID,
                    "tries"     : "0",
                    "topped"    : false
                    
                ])
            } catch let error {
                print("creating enrollment \(error)")
            }
        }
    }
    
    func fetchAllSeasons() async {
        let seasons = await getAllSeasons()
        
        DispatchQueue.main.async {
            self.seasons = seasons
        }
    }
    
    func getAllSeasons() async  -> [Season] {
        do {
            let snapshot = try await Firestore.firestore().collection("rounds").getDocuments()
            return snapshot.documents.compactMap {try? $0.data(as: Season.self)}
        } catch {
            return []
        }
    }
}



