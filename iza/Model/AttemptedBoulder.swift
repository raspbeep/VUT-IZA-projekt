//
//  AttemptedBoulder.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation

struct AttemptedBoulder: Identifiable {
    var id: String
    var boulder: Boulder
    var attempt: Attempt
    
    
    // copy function for comparing changes in BoulderSheet
    func copy() -> AttemptedBoulder {
        let copy = AttemptedBoulder(id: UUID().uuidString, boulder: self.boulder, attempt: self.attempt)
        return copy
    }
    
    mutating func setFromCopy(copyFrom: AttemptedBoulder) {
        self.attempt.tries = copyFrom.attempt.tries
        self.attempt.topped = copyFrom.attempt.topped
    }
}
