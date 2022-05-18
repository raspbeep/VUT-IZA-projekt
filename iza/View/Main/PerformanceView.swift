//
//  FavoritesView.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import SwiftUI
import SwiftUICharts


struct PerformanceView: View {
    @EnvironmentObject var loginModel: LoginViewModel
    @EnvironmentObject var firestoreManager: FirestoreManager
    @EnvironmentObject var dateViewModel: DateViewModel
    
    @State var attemptedBoulders = [AttemptedBoulder]()
    @State var currentBoulders = [AttemptedBoulder]()
    @State var summary = [MonthScore]()
    @State var barChartData = [(String, Double)]()
    @State var pieChartData = [Double]()
    
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
                    BarChartView(data: ChartData(values: barChartData), title: "Tops each month", form: ChartForm.extraLarge, valueSpecifier: "Number of tops: %.0f")
                        .padding(.bottom, 15)
                    
                    Text("Ratio of climbed boulders this month")
                    PieChartView(data: pieChartData, title: "Ratio of topped boulders this month", form: ChartForm.extraLarge)
                }
            } else {
                Spacer()
                Text("No data to visualize")
                Text("Enroll in the current challenge!")
                Spacer()
            }
        }
        .onAppear {
            Task {
                let allBoulders = await firestoreManager.getSeason(year: nil, month: nil, userID: loginModel.auth.currentUser?.uid)
                let currentBoulders = await firestoreManager.getSeason(year: dateViewModel.currentYear, month: dateViewModel.currentMonth, userID: loginModel.auth.currentUser?.uid)
                
                DispatchQueue.main.async {
                    self.attemptedBoulders = allBoulders
                    self.currentBoulders = currentBoulders
                    self.barChartData = self.generateBarChartData()
                    self.pieChartData = self.generatePieChartData()
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
            if score.boulder.month == dateViewModel.currentMonth && score.boulder.year == dateViewModel.currentYear {
                total += 1
                if score.attempt.topped == true {
                    topped += 1
                }
            }
        }
        print([total-topped, topped])
        return [total-topped, topped]
    }
}

struct MonthScore: Identifiable {
    var id: UUID
    var month: String
    var topCount: Double
}
