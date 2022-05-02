//
//  TabBar.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI


//enum colorClimbed: String {
//    case "climbed": Color.lightGreenCard
//    case Color.
//
//}

struct TabBar: View {
    @Binding var selection: Int
    
    var body: some View {
        TabView (selection: $selection){
            NavigationView {
                LeaderboardView()
            }
                .tabItem {
                    Text("Home")
                    Image(systemName: "chart.bar.fill")
                }
                .tag(1)
                .navigationViewStyle(.stack)
                
            
            NavigationView {
                SeasonsView()
            }
                .tabItem {
                    Label("Previous", systemImage: "calendar")
                }
                .tag(2)
                .navigationViewStyle(.stack)
            
            NavigationView {
                CurrentSeasonView()
                    .environmentObject(BoulderViewModel())
            }
            
                .tabItem {
                    Label("Current", systemImage: "plus")
                }
                .tag(3)
                .navigationViewStyle(.stack)
            
            NavigationView {
                FavoritesView()
            }
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(4)
                .navigationViewStyle(.stack)
            
            NavigationView {
                SettingsView()
            }
            
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(5)
                .navigationViewStyle(.stack)
        }
        .accentColor(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/)
    }
}
