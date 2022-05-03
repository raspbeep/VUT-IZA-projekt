//
//  AttemptRepository.swift
//  iza
//
//  Created by Pavel Kratochvil on 03.05.2022.
//

import Foundation
import FirebaseFirestore
import Combine


final class AttemptRepository: ObservableObject {
    private let path: String = "attempts"
    private let store = Firestore.firestore()
    @Published var attempts: [Attempt] = []
    
    init() {
        get()
    }
    
    func get() {
        store.collection(path).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            
            self.attempts = snapshot?.documents.compactMap {
                try? $0.data(as: Attempt.self)
            } ?? []
        }
    }
    
    func add(_ attempt: Attempt) {
        do {
            _ = try store.collection(path).addDocument(from: attempt)
        } catch {
            fatalError("Adding attempt to boulder with ID \(attempt.boulderID) failed")
        }
    }
    
    func update(_ attempt: Attempt) {
        guard let documentID = attempt.id else { return }
        do {
            try store.collection(path).document(documentID).setData(from: attempt)
        } catch {
            fatalError("Adding attempt to boulder with ID \(attempt.boulderID) failed")
        }
    }
}
