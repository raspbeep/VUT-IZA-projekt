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
    let email: String
    let firstName: String
    let lastName: String
    let nickName: String
    let dateOfBirth: Date
    let gender: String
    let category: climbingCategory.RawValue
}
