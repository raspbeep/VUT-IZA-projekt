//
//  UserScore.swift
//  iza
//
//  Created by Pavel Kratochvil on 04.05.2022.
//

import Foundation

struct UserScore: Identifiable {
    var id: String
    var user: User
    var tops: String
    var tries: String
}
