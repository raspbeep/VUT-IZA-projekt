//
//  BoulderService.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation
import Firebase


struct SeasonService {
    
    enum BoulderServiceError: Error {
        case failed
        case failedToDecode
        case invalidStatusCode
    }
    
    func fetchSeasons() async throws -> [Season] {
        let db = Firestore.firestore()
        let snapshot = try await db .collection("seasons")
                                    .getDocuments()
        
        return snapshot.documents.map { doc in
            return Season(
                id: doc.documentID,
                year: doc["year"] as! String,
                month: doc["month"] as! String,
                boulders: [Boulder(id: UUID().uuidString, year: "2022", month: "April", number: "12", sector: "Nose", color: "red", grade: "8a+")]
            )
        }
    }
}
