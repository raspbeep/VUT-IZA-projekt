//
//  BoulderService.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation
import Firebase


struct AttemptService {
    let baseQuery: Query = Firestore.firestore().collection("attempts")
    
    enum AttemptServiceError: Error {
        case failed
        case failedToDecode
        case invalidStatusCode
    }
    
    func fetchAttempts(forUser: String) async throws -> [Attempt] {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("attempts")
                    .whereField("userID", isEqualTo: forUser)
                    .getDocuments()

        return snapshot.documents.map { doc in
            return Attempt(
                id: doc.documentID,
                boulderID: doc["boulderID"] as! String,
                userID: doc["userID"] as! String,
                tries: doc["tries"] as! String,
                topped: doc["topped"] as! Bool
            )
        }
    }
    
    func changeQuery(boulderID: String?, userID: String?, grade: String?/*, sortOption: String?*/) -> Query {
        var filteredQuery = baseQuery

        if let boulderID = boulderID {
          filteredQuery = filteredQuery.whereField("boulderID", isEqualTo: boulderID)
        }

        if let userID = userID {
          filteredQuery = filteredQuery.whereField("userID", isEqualTo: userID)
        }

        if let grade = grade {
          filteredQuery = filteredQuery.whereField("grade", isEqualTo: grade)
        }

        return filteredQuery
      }
}
