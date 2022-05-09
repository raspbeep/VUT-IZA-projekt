//
//  FavoritesView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI
import SwiftUICharts


struct FavoritesView: View {
    @EnvironmentObject var loginModel: LoginViewModel
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State var attemptedBoulders = [AttemptedBoulder]()
    @State var currentBoulders = [AttemptedBoulder]()
    @State var summary = [MonthScore]()
    var currentYear: String = "2022"
    var currentMonth: String = "April"
    @State var barChartData = [(String, Double)]()
    
    @State var data = [(String, Int)]()
    
    var body: some View {
        VStack {
            HStack {
                Text("My Performance")
                    .font(.system(size: 30, weight: .bold))
                    
                Spacer()
            }
            .padding([.top, .horizontal])
            
            if barChartData.count > 0 {
                VStack {
                    BarChartView(data: ChartData(values: self.generateBarChartData()), title: "Tops in rounds", form: ChartForm.extraLarge, valueSpecifier: "Number of tops: %.0f")
                    
                    PieChartView(data: self.generatePieChartData(), title: "Title", form: ChartForm.extraLarge)
                    
                    List {
                        ForEach(self.$attemptedBoulders) { $attemptedBoulder in
                            Text(attemptedBoulder.boulder.number)
                            Text(attemptedBoulder.boulder.sector)
                            Text(attemptedBoulder.boulder.grade)
                        }
                            .listStyle(PlainListStyle())
                    }
                        .padding()
                }
            } else {
                Spacer()
                Text("No data to visualize")
                Text("Enroll in current challenge!")
                Spacer()
            }
        }
        .onAppear {
            Task {
                let allBoulders = await firestoreManager.getSeason(year: nil, month: nil, userID: loginModel.auth.currentUser?.uid)
                let currentBoulders = await firestoreManager.getSeason(year: currentYear, month: currentMonth, userID: loginModel.auth.currentUser?.uid)
                
                DispatchQueue.main.async {
                    self.attemptedBoulders = allBoulders
                    self.currentBoulders = currentBoulders

                    self.barChartData = self.generateBarChartData()
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    func generateSummary() -> [MonthScore] {
        var summary = [MonthScore]()
        
        if !attemptedBoulders.isEmpty {
            for attemptedBoulder in attemptedBoulders {
                if let monthScoreIndex = summary.firstIndex(where: { attemptedBoulder.boulder.month == $0.month }) {
                    if attemptedBoulder.attempt.topped {
                        summary[monthScoreIndex].topCount += 1
                    }
                } else {
                    var newMonthScore = MonthScore(id: UUID(), month: attemptedBoulder.boulder.month, topCount: 0.0)
                    if attemptedBoulder.attempt.topped {
                        newMonthScore.topCount += 1
                    }
                    summary.append(newMonthScore)
                }
            }
        }
        return summary
    }
    
    func generateBarChartData() -> [(String, Double)] {
        var graphData = [(String, Double)]()
        for monthScore in self.generateSummary() {
            graphData.append((monthScore.month, monthScore.topCount))
        }
        return graphData
    }
    
    func generatePieChartData() -> [Double] {
        var total: Double = 0.0
        //var flashed: Int = 0
        var topped: Double = 0.0

        for score in self.attemptedBoulders {
            if score.boulder.month == self.currentMonth && score.boulder.year == currentYear {
                total += 1
                if score.attempt.topped == true {
                    topped += 1
//                    if score.attempt.tries == 2 {
//                        flashed +=1
//                    }
                }
            }
        }
        return [total-topped, topped]
    }
}

struct MonthScore: Identifiable {
    var id: UUID
    var month: String
    var topCount: Double
}
