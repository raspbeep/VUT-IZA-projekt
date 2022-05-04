//
//  Boulder.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Boulder: Identifiable, Codable {
    @DocumentID var id: String?
    var year: String
    var month: String
    var number: String
    var sector: String
    var color: String
    var grade: String
    var label: String
}
