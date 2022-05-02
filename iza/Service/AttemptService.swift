//
//  BoulderService.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation
import Firebase


struct AttemptService {
    //var forUser: String
    
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
}
