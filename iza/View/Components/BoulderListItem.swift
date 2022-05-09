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
    
    let categories = ["crimp", "sloper"]
    
    var cardColor: Color
    {
        if attemptedBoulder.attempt.topped {
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
                                Text("\(attemptedBoulder.boulder.number)/30")
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 5)
                            }
                            
                            Spacer()
                            
                            Text("\(attemptedBoulder.boulder.grade)")
                                .font(.system(size: 45, weight: .bold))
                                .foregroundColor(Color.red)
                                
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    VStack(alignment: .trailing) {
                    HStack {
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
                                Text("\(attemptedBoulder.boulder.sector)")
                            }
                            .padding(.bottom, 5)
                            
                            if let labelText = attemptedBoulder.boulder.label {
                                HStack {
                                
                                    SmallLabel(text: labelText)
                                }
                                
                            }
                        }
                    }
                    }
                    .padding(.trailing, 10)
                    
                    HStack {
                        if attemptedBoulder.attempt.tries == "1" && attemptedBoulder.attempt.topped == true {
                            VStack {
                                Label("Flashed", systemImage: "bolt.fill")
                            }
                        } else {
                            VStack {
                                HStack {
                                    Spacer()

                                    Text("Tries:")
                                        .padding(.bottom, 5)

                                    Text(attemptedBoulder.attempt.tries)
                                        .font(.system(size: 25, weight: .semibold))
                                        .padding(.bottom, 5)

                                    Spacer()
                                }
                                .padding(.top)

                                Spacer()
                                HStack {
                                    Spacer()
                                    if attemptedBoulder.attempt.topped == true {
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
                                

                                Spacer()
                            }
                        }
                    }
                    Spacer()
                    
                }
                .padding(.vertical, 5)
            }
            .background(cardColor)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
        }
}

struct BoulderSheet_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSeasonView()
    }
}
