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
    
    let categories = ["crimp", "sloper"]
    
    var body: some View {
        ZStack(alignment: .leading) {
                Color.secondary
                HStack {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.red, .blue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        VStack {
                            Text("\(boulder.grade)")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 90, height: 90, alignment: .center)
                    
                    VStack(alignment: .leading) {
                        Text("Color: \(boulder.color)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .padding(.bottom, 5)
                        
                        Text("Color: \(boulder.color)")
                            .padding(.bottom, 5)
                        
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
                    
                    VStack {
                        Spacer()
                        Text("")
                        Spacer()
                        
                    }
                }
                .padding(15)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.top, 10)
            .padding([.leading, .trailing], 15)
        }
        
}

struct BoulderDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        ScrollView (.vertical, showsIndicators: true) {
            NavigationLink(destination: Text("Hello")) {
                BoulderDetail(boulder: Boulder(id: "15616", year: "2022", month: "January", number: "15", sector: "nose", color: "red", grade: "8a+", photo: "smth", url: "www.google.com"))
                    
            }
            
            BoulderDetail(boulder: Boulder(id: "15616", year: "2022", month: "January", number: "15", sector: "nose", color: "red", grade: "8a+", photo: "smth", url: "www.google.com"))
            BoulderDetail(boulder: Boulder(id: "15616", year: "2022", month: "January", number: "15", sector: "nose", color: "red", grade: "8a+", photo: "smth", url: "www.google.com"))
        }
        .padding(.top, 10)
        }
    }
}
