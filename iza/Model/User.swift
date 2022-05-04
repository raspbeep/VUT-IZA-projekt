//
//  CurrentUser.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var uid: String
    var email: String
    var firstName: String
    var lastName: String
    var nickName: String
    var dateOfBirth: String
    var gender: String
    var category: String
}
