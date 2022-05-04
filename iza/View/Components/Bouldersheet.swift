//
//  Bouldersheet.swift
//  iza
//
//  Created by Pavel Kratochvil on 29.04.2022.
//

import Foundation
import SwiftUI
import Combine


struct BoulderSheet: View {
    @StateObject var firestoreManager: FirestoreManager = FirestoreManager()
    @Binding var attemptedBoulder: AttemptedBoulder
    @State var boulderHasChanged: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    Text(boulderHasChanged.description)
                    Text(attemptedBoulder.boulder.year)
                    Text(attemptedBoulder.boulder.month)
                    Text(attemptedBoulder.boulder.number)
                        .fontWeight(.semibold)
                    
                    Text(attemptedBoulder.boulder.sector)
                    Text(attemptedBoulder.boulder.color)
                    Text(attemptedBoulder.boulder.grade)
                    Text(attemptedBoulder.boulder.label)
                    
                    Text(attemptedBoulder.attempt.topped.description)
                    Text(attemptedBoulder.attempt.tries)
                }
                
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        self.boulderHasChanged = true
                        if self.attemptedBoulder.attempt.tries != "0" {
                            self.attemptedBoulder.attempt.tries = String(Int(self.attemptedBoulder.attempt.tries)! - 1)
                        }
                        
                        }) {
                        Image(systemName: "minus")
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color.black)
                            .background(Color.lightGreenCard)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        self.boulderHasChanged = true
                        self.attemptedBoulder.attempt.tries = String(Int(self.attemptedBoulder.attempt.tries)! + 1)
                        }) {
                        Image(systemName: "plus")
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color.lightRedCard)
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                
                
                VStack {
                   Text("Topped")
                       .foregroundColor(attemptedBoulder.attempt.topped ? .green : .gray)
                   Toggle("boulder", isOn: $attemptedBoulder.attempt.topped)
                       .labelsHidden()
                    }.padding()
                     .overlay(
            
                        RoundedRectangle(cornerRadius: 15)
                       .stroke(lineWidth: 2)
                       .foregroundColor(attemptedBoulder.attempt.topped ? .green : .gray)
                    )
            }
            
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

            Spacer()
        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(
//            leading:
//                Button(action : { dismiss() }){
//                    Text("Cancel")
//                },
//            trailing:
//
//                Button(action : {
//                    dismiss()
//                    Task {
//                        if self.boulderHasChanged {
//                            try await firestoreManager.changeAttemptedBoulder(attemptedBoulder: self.attemptedBoulder)
//
//                        }
//                    }
//                }){
//                    Text("Save")
//
//                })
            
        
    }
}




