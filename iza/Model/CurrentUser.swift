//
//  CurrentUser.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import Foundation


struct User: Identifiable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let nickName: String
    let dateOfBirth: Date
    let gender: String
    let category: Category.RawValue
}
