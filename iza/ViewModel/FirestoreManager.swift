//
//  FirestoreManager.swift
//  iza
//
//  Created by Pavel Kratochvil on 03.05.2022.
//

import Foundation
import Firebase
import FirebaseFirestore

// Manager for interactitng with the database, stores all necessary information in published variables for further usage in section Leaderboard, Previous, Current
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
    
    // gets documents from collection attempts according to specifying filters
    func getAttempts(boulderID: String?, userID: String?, forBoulderIDs: [String]?) async -> [Attempt] {
        var newQuery: Query = Firestore.firestore().collection("attempts")
        
        if let boulderID = boulderID {
            newQuery = newQuery.whereField("boulderID", isEqualTo: boulderID)
        }
        
        if let userID = userID {
            newQuery = newQuery.whereField("userID", isEqualTo: userID)
        }
        
        if let forBoulderIDs = forBoulderIDs {
            if forBoulderIDs.count > 0 {
                newQuery = newQuery.whereField("boulderID", in: forBoulderIDs)
            }
        }
        
        do {
            let snapshot = try await newQuery.getDocuments()
            return snapshot.documents.compactMap {try? $0.data(as: Attempt.self)}
        } catch {
            print("Error fetching attempts")
            return []
        }
    }
    
    // gets documents from collection boulders according to specifying filters
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
            print("Error fetching attempts")
            return []
        }
    }
    
    // gets documents from users attempts according to specifying filters
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
    
    // fetches specified season and assigns it to a published variable
    func fetchSeasons(year: String, month: String, userId: String?) async {
        let season = await getSeason(year: year, month: month, userID: userId)
        
        DispatchQueue.main.async {
            self.attemptedBoulders = season
        }
    }
    
    // fetches specified boulders, attempts, compiles them and assigns them to published a variable
    func getSeason(year: String?, month: String?, userID: String?) async -> [AttemptedBoulder] {
        let b = await getBoulders(year: year, month: month)
        let a = await getAttempts(boulderID: nil, userID: userID, forBoulderIDs: nil)
        
        var compiled = compile(boulders: b, attempts: a)
        compiled.sort(by: { Int($0.boulder.number)! < Int($1.boulder.number)! })
        return compiled
    }
    
    // finds attempt document to each boulder document and returns in compiled structure
    func compile(boulders: [Boulder], attempts: [Attempt]) -> [AttemptedBoulder] {
        var returnVal = [AttemptedBoulder]()
        for boulder in boulders {
            if let attempt = getAttemptForBoulder(boulder: boulder, attempts: attempts) {
                returnVal.append(AttemptedBoulder(id: UUID().uuidString, boulder: boulder, attempt: attempt))
            }
        }
        return returnVal
    }
    
    // helper function for finding attempt record for a specified boulder
    func getAttemptForBoulder(boulder: Boulder, attempts: [Attempt]) -> Attempt? {
        for attempt in attempts {
            if attempt.boulderID == boulder.id {
                return attempt
            }
        }
        return nil
    }
    
    // writes the change of attempted boulder to database
    // used when the user change number of tries or topped boolean in BoulderDetail
    func changeAttemptedBoulder(attemptedBoulder: AttemptedBoulder) async throws {
        do {
            if let docID = attemptedBoulder.attempt.id {
                try Firestore.firestore().collection("attempts").document(docID).setData(from: attemptedBoulder.attempt)
            }
        } catch {
            print("Error fetching attempts")
        }
    }
    
    // fetches specified leaderboard and assigns it to a published variable
    func fetchLeaderBoard(year: String?, month: String?) async {
        let leaderboard = await getLeaderBoard(year: year, month: month)
        
        DispatchQueue.main.async {
            self.leaderboard = leaderboard
        }
    }
    
    //
    func getLeaderBoard(year: String?, month: String?) async -> [UserScore] {
        // get list of boulders for a specified season
        let listOfBoulders = await getBoulders(year: year, month: month)
        
        var boulderIDs = [String]()
        for boulder in listOfBoulders {
            boulderIDs.append(boulder.id ?? "")
        }
        
        // get list of attempts for a specified season
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
        
        // gets all users participating in spefified season to show further information about them in the leaderboard
        let users = await getUsers(forIDs: userIDs)
        
        // create score record items to display in leaderboard
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
        
        // sorting first by the number of topped boulders then by attempts
        userScores.sort(by: { Int($0.tries)! < Int($1.tries)! })
        userScores.sort(by: { Int($0.tops)! > Int($1.tops)! })
        
        return userScores
        
    }

    // checks whether the user is enrolled in the current season
    // achieved by returning the number of AttemptedBoulder struct for the current season
    func checkEnrollment(year: String, month: String, userID: String) async  -> Int {
        let boulders = await getBoulders(year: year, month: month)
        var boulderIDs = [String]()
        for boulder in boulders {
            boulderIDs.append(boulder.id ?? "")
        }
        let attempts = await getAttempts(boulderID: nil, userID: userID, forBoulderIDs: boulderIDs)
        return attempts.count
    }
    
    // user is not signed up in the current challenge by default
    // each month, user can opt to participate, empty (0 tops, 0 tries) AttemptedBoulder structs are created and stored in the database
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
    
    // fetches the list of all seasons
    // results in a list of structs (Year, Month) to display written in a published variable to show in section Previous
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
