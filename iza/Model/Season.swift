//
//  Seasons.swift
//  iza
//
//  Created by Pavel Kratochvil on 03.05.2022.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Season: Identifiable, Codable {
    @DocumentID var id: String?
    var year: String
    var month: String
}
