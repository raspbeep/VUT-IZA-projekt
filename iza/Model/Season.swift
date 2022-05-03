//
//  Season.swift
//  iza
//
//  Created by Pavel Kratochvil on 02.05.2022.
//

struct Season: Identifiable {
    var id: String
    var year: String
    var month: String
    var boulders: [Boulder]
}
