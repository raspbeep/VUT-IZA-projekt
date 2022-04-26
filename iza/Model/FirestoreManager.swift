//
//  FirestoreManager.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import Foundation
import Firebase

class FirestoreManager: ObservableObject {
    @Published var listOfBoulders: [Boulder]
    
    init() {
        listOfBoulders = [Boulder]()
        
        getBoulders()
    }


    func getBoulders() {
        let db = Firestore.firestore()
        print("connecting")
        db.collection("boulders").getDocuments { snapshot, error in
            if error != nil {
                print(error!)
                return
            }
            if let snapshot = snapshot {
                DispatchQueue.main.async {
                    self.listOfBoulders = snapshot.documents.map { doc in
                        print(doc["year"] as! String)
                        return Boulder(
                            id: doc.documentID,
                            year: doc["year"] as! String,
                            month: doc["month"] as! String,
                            number: doc["number"] as! String,
                            sector: doc["sector"] as! String,
                            color: doc["color"] as! String,
                            grade: doc["grade"] as! String,
                            photo: doc["photo"] as! String,
                            url: doc["url"] as! String)
                    }
                }
            }
        }
    }
}
