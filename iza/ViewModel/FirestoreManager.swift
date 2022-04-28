//
//  FirestoreManager.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import Foundation
import Firebase
import SwiftUI
import Promises


class FirestoreManager: ObservableObject {
    
    @Published var listOfBoulders: [Boulder]
    @Published var listOfAttempts: [Attempt]
    @Published var listOfBouldersWithAttempts: [AttemptedBoulder]


    @Published var gotBoulders: Bool = false
    @Published var gotAttempts: Bool = false
    @Published var gotBoulderAttempts: Bool = false
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    let currentSeasonQuery: Query = Firestore.firestore().collection("boulders").limit(to: 30)
    
    private var currentYear: String
    private var currentMonth: String

    
    
    init () {
        print("init")
        listOfBoulders = [Boulder]()
        listOfAttempts = [Attempt]()
        listOfBouldersWithAttempts = [AttemptedBoulder]()
        
        currentYear = "2022"
        currentMonth = "April"
    }
}
