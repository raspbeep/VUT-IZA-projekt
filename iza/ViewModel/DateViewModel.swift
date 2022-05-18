//
//  DateViewModel.swift
//  iza
//
//  Created by Pavel Kratochvil on 18.05.2022.
//

import Foundation
import SwiftUI


class DateViewModel: ObservableObject {
    @Published var currentYear: String
    @Published var currentMonth: String
    
    init() {
        self.currentYear = String(Calendar.current.component(.year, from: Date()))
        self.currentMonth = Calendar.current.monthSymbols[Calendar.current.component(.month, from: Date())-1]
    }
}
