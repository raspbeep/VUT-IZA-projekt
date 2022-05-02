//
//  BoulderDetail.swift
//  iza
//
//  Created by Pavel Kratochvil on 26.04.2022.
//

import Foundation
import SwiftUI

struct BoulderDetail: View {
    var boulder: Boulder
    let attempt: Attempt
    
    let categories = ["crimp", "sloper"]
    
    private var cardColor: Color {
        if attempt.topped {
            return Color.lightGreenCard
        }
        return Color.lightRedCard
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
                HStack {
                    Spacer()
                    HStack {
                        VStack (alignment: .trailing) {
                            HStack {
                                Text("\(boulder.number)/30")
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 5)
                            }
                            
                            Spacer()
                            
                            Text("\(boulder.grade)")
                                .font(.system(size: 45, weight: .bold))
                                .foregroundColor(Color.red)
                                
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment:.leading) {
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
                            Text("\(boulder.sector)")
                        }
                        .padding(.bottom, 5)
                        
                        HStack {
                            ForEach(categories, id: \.self) { category in
                                CategoryPill(categoryName: category)
                            }
                        }
                    }
                    
                    
                    Spacer()
                    
                    HStack {
                        if attempt.tries == "1" && attempt.topped == true {
                            VStack {
                                Label("Flashed", systemImage: "bolt.fill")
                            }
                        } else {
                            VStack {
                                HStack {
                                    Spacer()
                                    
                                    Text("Attempts:")
                                        .padding(.bottom, 5)
                                    
                                    Text(attempt.tries)
                                        .font(.system(size: 25, weight: .semibold))
                                        .padding(.bottom, 5)
                                    
                                    Spacer()
                                }
                                .padding(.top)
                                
                                Spacer()
                                
                                if attempt.topped == true {
                                    Label("", systemImage: "checkmark")
                                        .font(.system(size: 35, weight: .semibold))
                                        .foregroundColor(Color.red)
                                    
                                } else {
                                    Label("", systemImage: "xmark")
                                        .font(.system(size: 35, weight: .semibold))
                                        .foregroundColor(Color.red)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    Spacer()
                    
                }
                .padding(.vertical)
            }
        .background(cardColor)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.top, 10)
            .padding([.leading, .trailing], 15)
            
        }
}

struct BoulderDetail_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            ScrollView (.vertical, showsIndicators: true) {
                VStack {
                    Button(action: {
                        
                    }, label: {
                        BoulderDetail(boulder: Boulder(id: "15616", year: "2022", month: "January", number: "15", sector: "Nose", color: "red", grade: "8a+"), attempt: Attempt(id: "smth", boulderID: "smth", userID: "smth", tries: "2", topped: false))
                    })
                    Button(action: {
                        
                    }, label: {
                        BoulderDetail(boulder: Boulder(id: "15616", year: "2022", month: "January", number: "15", sector: "Nose", color: "red", grade: "7c+"), attempt: Attempt(id: "smth", boulderID: "smth", userID: "smth", tries: "4", topped: true))
                    })
                    Button(action: {
                        
                    }, label: {
                        BoulderDetail(boulder: Boulder(id: "15616", year: "2022", month: "January", number: "15", sector: "Nose", color: "red", grade: "8a+"), attempt: Attempt(id: "smth", boulderID: "smth", userID: "smth", tries: "1", topped: true))
                    })
                //Vstack
                }
            // ScrollView closure
            }
             .buttonStyle(PlainButtonStyle())

        // NavigationView
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .padding(.top, 10)
    }
}
