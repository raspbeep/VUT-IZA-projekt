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
    
    
    var body: some View {
        TabView (selection: .constant(1)){
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
                CategoriesView()
            }
                .tabItem {
                    Label("Categories", systemImage: "square.fill.text.grid.1x2")
                }
                .tag(2)
                .navigationViewStyle(.stack)
            
            NavigationView {
                CurrentSeasonView()
                    .environmentObject(BoulderViewModel(
                        boulderService: BoulderService(), attemptService: AttemptService()
                    ))
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

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
