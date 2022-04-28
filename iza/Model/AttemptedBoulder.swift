//
//  AttemptedBoulder.swift
//  iza
//
//  Created by Pavel Kratochvil on 28.04.2022.
//

import Foundation

struct AttemptedBoulder: Identifiable {
    var id: UUID
    var boulder: Boulder
    var attempt: Attempt
}
