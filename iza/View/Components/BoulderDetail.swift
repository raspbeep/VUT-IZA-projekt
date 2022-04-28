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
                    HStack{
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
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        
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
                    .padding(.horizontal, 5)
                    
                    Spacer()
                    
                    HStack {
                        VStack {
                            Spacer()
                            Text("Attempts")
                                .padding(.bottom, 5)
                            
                            Text(attempt.tries)
                                .font(.system(size: 30, weight: .semibold))
                            Spacer()
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
        
        NavigationView {
            ScrollView (.vertical, showsIndicators: true) {
                VStack {

                    NavigationLink(destination: Text("Hello")) {
                        BoulderDetail(boulder: Boulder(id: "15616", year: "2022", month: "January", number: "15", sector: "Nose", color: "red", grade: "8a+", photo: "smth", url: "www.google.com"), attempt: Attempt(id: "smth", boulderID: "smth", userID: "smth", tries: "2", topped: false))
                    }

                    NavigationLink(destination: Text("Hello")) {
                        BoulderDetail(boulder: Boulder(id: "15616", year: "2022", month: "January", number: "15", sector: "Nose", color: "red", grade: "7c+", photo: "smth", url: "www.google.com"), attempt: Attempt(id: "smth", boulderID: "smth", userID: "smth", tries: "4", topped: true))
                    }

                    NavigationLink(destination: Text("Hello")) {
                        BoulderDetail(boulder: Boulder(id: "15616", year: "2022", month: "January", number: "15", sector: "Nose", color: "red", grade: "8a+", photo: "smth", url: "www.google.com"), attempt: Attempt(id: "smth", boulderID: "smth", userID: "smth", tries: "25", topped: true))
                    }

                //Vstack
                }
            // ScrollView closure
            }
             .buttonStyle(PlainButtonStyle())

        // NavigationView
        }
        .navigationTitle("Current season")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top, 10)
        
//        BoulderDetail(boulder: Boulder(id: "15616", year: "2022", month: "January", number: "15", sector: "nose", color: "red", grade: "8a+", photo: "smth", url: "www.google.com"))
        
    }
}
