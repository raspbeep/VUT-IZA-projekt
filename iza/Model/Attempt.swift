//
//  Attempt.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation

struct Attempt: Identifiable {
    var id: String
    var boulderID: String
    //var reference: DocumentReference?
    var userID: String
    var tries: String
    var topped: Bool
}
