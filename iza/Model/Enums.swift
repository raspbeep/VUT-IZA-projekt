//
//  Enums.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation


let allGrades: [String] = ["8a+"]


enum Gender: String, CaseIterable {
    case male = "male"
    case female = "female"
}

enum climbingCategory: String, CaseIterable {
    case profi = "profi"
    case hobby = "hobby"
}
