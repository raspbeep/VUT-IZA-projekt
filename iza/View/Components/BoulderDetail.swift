//
//  Bouldersheet.swift
//  iza
//
//  Created by Pavel Kratochvil on 29.04.2022.
//

import Foundation
import SwiftUI
import Combine


struct BoulderDetailView: View {
    @StateObject var firestoreManager: FirestoreManager = FirestoreManager()
    @Binding var attemptedBoulder: AttemptedBoulder
    @State var boulderHasChanged: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack (alignment: .leading) {
            VStack (alignment: .leading) {
                HStack {
                    Text("Number:")
                    Text(attemptedBoulder.boulder.number)
                        .padding(.trailing)
                        .font(.system(size: 20, weight: .semibold))
                }
                
                HStack {
                    Text("Grade:")
                    Text(attemptedBoulder.boulder.grade)
                        .padding(.trailing)
                        .font(.system(size: 30, weight: .semibold))
                }
                
                HStack {
                    Text("Sector:")
                    Text(attemptedBoulder.boulder.sector)
                        .padding(.trailing)
                        .font(.system(size: 30, weight: .semibold))
                }
                    
                HStack {
                    Text("Color:")
                    Text(attemptedBoulder.boulder.color)
                        .padding(.trailing)
                        .font(.system(size: 30, weight: .semibold))
                }
                
                HStack {
                    Text("Number of attempts:")
                    Text(attemptedBoulder.attempt.tries)
                        .padding(.trailing)
                        .font(.system(size: 30, weight: .semibold))
                }
            }
            .padding(.leading, 10)
            
            HStack {
                Spacer()
                
                Button(action: {
                    self.boulderHasChanged = true
                    // cannot decrease bellow zero
                    if self.attemptedBoulder.attempt.tries != "0" {
                        self.attemptedBoulder.attempt.tries = String(Int(self.attemptedBoulder.attempt.tries)! - 1)
                    }
                }) {CircleButton(imageName: "minus", color: Color.lightRedCard)}
                
                Spacer()
                
                Button(action: {
                    self.boulderHasChanged = true
                    self.attemptedBoulder.attempt.tries = String(Int(self.attemptedBoulder.attempt.tries)! + 1)
                }) {CircleButton(imageName: "plus", color: Color.lightGreenCard)}
                Spacer()
            }
            
            HStack {
                Spacer()
                VStack {
                    VStack {
                       Text("Topped")
                           .foregroundColor(attemptedBoulder.attempt.topped ? .green : .gray)
                       Toggle("boulder", isOn: $attemptedBoulder.attempt.topped)
                           .labelsHidden()
                        }
                        .padding()
                        .overlay(
                           RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                            .foregroundColor(attemptedBoulder.attempt.topped ? .green : .gray)
                        )
                
                        Spacer()
                        
                        Button(action: {
                            dismiss()
                            Task {
                                try await firestoreManager.changeAttemptedBoulder(attemptedBoulder: self.attemptedBoulder)
                                self.attemptedBoulder.setFromCopy(copyFrom: attemptedBoulder)
                            }
                        }, label: {
                            Text("Save")
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .padding()
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
                                .cornerRadius(8.0)
                        })
                }
                Spacer()
            }
        }
        Spacer()
    }
}
