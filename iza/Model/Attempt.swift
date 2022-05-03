//
//  Attempt.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Attempt: Identifiable, Codable {
    @DocumentID var id: String?
    var boulderID: String
    //var reference: DocumentReference?
    var userID: String
    var tries: String
    var topped: Bool
}
