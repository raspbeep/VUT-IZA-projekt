//
//  BoulderService.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation
import Firebase


struct BoulderService {
    
    let baseQuery: Query = Firestore.firestore().collection("boulders")
    
    enum BoulderServiceError: Error {
        case failed
        case failedToDecode
        case invalidStatusCode
    }
    
    func fetchBoulders() async throws -> [Boulder] {
        let db = Firestore.firestore()
        let snapshot = try await db .collection("boulders")
                                    .whereField("year", isEqualTo: "2022")
                                    .whereField("month", isEqualTo: "April")
                                    .getDocuments()
        
        return snapshot.documents.map { doc in
            return Boulder(
                id: doc.documentID,
                year: doc["year"] as! String,
                month: doc["month"] as! String,
                number: doc["number"] as! String,
                sector: doc["sector"] as! String,
                color: doc["color"] as! String,
                grade: doc["grade"] as! String
            )
        }
    }
    
    func changeQuery(year: String?, month: String?, grade: Strin?/*, sortOption: String?*/) -> Query {
        var filteredQuery = baseQuery

        if let year = year {
          filteredQuery = filteredQuery.whereField("year", isEqualTo: year)
        }

        if let month = month {
          filteredQuery = filteredQuery.whereField("month", isEqualTo: month)
        }

        if let grade = grade {
          filteredQuery = filteredQuery.whereField("grade", isEqualTo: grade)
        }

        return filteredQuery
      }
}
