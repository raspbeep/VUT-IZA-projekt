//
//  BoulderRepository.swift
//  iza
//
//  Created by Pavel Kratochvil on 03.05.2022.
//

import Foundation
import FirebaseFirestore
import Combine


final class BoulderRepository: ObservableObject {
    private let path: String = "boulders"
    private let store = Firestore.firestore()
    @Published var boulders: [Boulder] = []
    
    init() {
        get()
    }
    
    func get() {
        store.collection(path).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            
            self.boulders = snapshot?.documents.compactMap {
                try? $0.data(as: Boulder.self)
            } ?? []
        }
    }

}
