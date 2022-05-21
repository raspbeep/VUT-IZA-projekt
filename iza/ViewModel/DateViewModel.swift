//
//  DateViewModel.swift
//  iza
//
//  Created by Pavel Kratochvil on 18.05.2022.
//

import Foundation
import SwiftUI

// used as environment variable for databse querys
class DateViewModel: ObservableObject {
    @Published var currentYear: String
    @Published var currentMonth: String
    
    let monthList = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    init() {
        self.currentYear = String(Calendar.current.component(.year, from: Date()))
        self.currentMonth = monthList[Calendar.current.component(.month, from: Date())-1]
    }
}
