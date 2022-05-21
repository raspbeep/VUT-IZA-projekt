//
//  BoulderDetail.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import Foundation
import SwiftUI

struct BoulderListItem: View {
    @Binding var attemptedBoulder: AttemptedBoulder
        
    var cardColor: Color
    {
        if attemptedBoulder.attempt.topped {
            return Color.lightGreenCard
        }
        return Color.lightRedCard
    }
    
    let myFont = Font
            .system(size: 34)
            .monospaced()
            .weight(.bold)
    
    var body: some View {
        ZStack {
            HStack {
                VStack (alignment: .leading) {
                    HStack {
                        VStack (alignment: .leading) {
                            VStack (alignment: .leading) {
                                Text("\(attemptedBoulder.boulder.number)/30")
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 5)
                            }
                            
                            if attemptedBoulder.boulder.grade.count == 2 {
                                Text("\(attemptedBoulder.boulder.grade) ")
                                    .font(myFont)
                                    .foregroundColor(Color.red)
                            } else {
                                Text("\(attemptedBoulder.boulder.grade)")
                                    .font(myFont)
                                    .foregroundColor(Color.red)
                            }
                        }
                        .padding(.trailing)
                    }
                    .padding()
                }
                
                Spacer()
                
                VStack (alignment: .leading) {
                    HStack {
                        (
                        Text("Color: ")
                        +
                        Text(Image(systemName: "circle.fill"))
                            .foregroundColor(.red)
                        )
                        .font(.headline)
                        .lineLimit(1)
                        .padding(.bottom, 5)
                    }
                    
                    HStack(alignment: .center) {
                        Image(systemName: "mappin")
                        Text("\(attemptedBoulder.boulder.sector)")
                    }
                    .padding(.bottom, 5)
                    
                    if let labelText = attemptedBoulder.boulder.label {
                        HStack {
                        
                            SmallPillLabel(text: labelText)
                        }
                        
                    }
                }
                        
                if attemptedBoulder.attempt.tries == "1" && attemptedBoulder.attempt.topped == true {
                    VStack {
                        HStack {
                            Spacer()
                            HStack {
                                Text("Flashed")
                                    .fontWeight(.semibold)
                                Image(systemName: "bolt.fill")
                                    .foregroundColor(Color.lightRedError)
                            }
                                
                            Spacer()
                        }
                    }
                } else {
                    VStack {
                        
                        Text("Tries: \(attemptedBoulder.attempt.tries)")
                            .font(.system(size: 20, weight: .semibold))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom)
                        HStack {
                            Spacer()
                            if attemptedBoulder.attempt.topped == true {
                                Label("", systemImage: "checkmark")
                                    .font(.system(size: 35, weight: .semibold))
                                    .foregroundColor(Color.lightRedError)
                            } else {
                                Label("", systemImage: "xmark")
                                    .font(.system(size: 35, weight: .semibold))
                                    .foregroundColor(Color.lightRedError)
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
        .background(cardColor)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        
    }
}

struct BoulderListItem_Preview: PreviewProvider {
    @State static var ab1: AttemptedBoulder = AttemptedBoulder(id: UUID().uuidString, boulder: Boulder(id: "id", year: "2022", month: "May", number: "15", sector: "Nose", color: "Red", grade: "8A+", label: "jugs"), attempt: Attempt(boulderID: UUID().uuidString, userID: "", tries: "15", topped: true))
    @State static var ab2: AttemptedBoulder = AttemptedBoulder(id: UUID().uuidString, boulder: Boulder(id: "id", year: "2022", month: "May", number: "15", sector: "Nose", color: "Red", grade: "8A", label: "jugs"), attempt: Attempt(boulderID: UUID().uuidString, userID: "", tries: "15", topped: true))
    @State static var ab3: AttemptedBoulder = AttemptedBoulder(id: UUID().uuidString, boulder: Boulder(id: "id", year: "2022", month: "May", number: "1", sector: "Center", color: "Red", grade: "6C+", label: "crimps"), attempt: Attempt(boulderID: UUID().uuidString, userID: "", tries: "1", topped: true))
    static var previews: some View {
        VStack (alignment: .leading) {
            NavigationView {
                VStack {
                    List {
                        ZStack {
                            NavigationLink(destination: EmptyView()) {
                                EmptyView()
                            }
                            
                            .padding(0)
                            .opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                                
                            HStack {
                                BoulderListItem(attemptedBoulder: $ab1)
                            }
                        }
                        ZStack {
                            NavigationLink(destination: EmptyView()) {
                                EmptyView()
                            }
                            
                            .padding(0)
                            .opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                                
                            HStack {
                                BoulderListItem(attemptedBoulder: $ab2)
                            }
                        }
                        ZStack {
                            NavigationLink(destination: EmptyView()) {
                                EmptyView()
                            }
                            
                            .padding(0)
                            .opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                                
                            HStack {
                                BoulderListItem(attemptedBoulder: $ab3)
                            }
                        }
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .listStyle(PlainListStyle())
                }
            }
        }
    }
}
