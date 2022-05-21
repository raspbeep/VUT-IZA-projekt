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
    
    @State var hardestGrader: String = ""
    @State var averageGrade: String = ""
    
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

                    Text("Top climbed grade: \(hardestGrader)")
                    Text("Average grade: \(averageGrade)")
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
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    func generateSummary() -> [MonthScore] {
        var summary = [MonthScore]()
        var hardest: Int = 0
        var average: Int = 0
        var count: Int = 0
        var idx: Int
        
        if !attemptedBoulders.isEmpty {
            for attemptedBoulder in attemptedBoulders {
                if attemptedBoulder.attempt.topped {
                    count += 1
                    idx = grades.firstIndex(where: { $0 == attemptedBoulder.boulder.grade })!
                    average += idx
                    if idx > hardest {
                        hardest = idx
                    }
                    
                    if let monthScoreIndex = summary.firstIndex(where: { attemptedBoulder.boulder.month == $0.month }) {
                            summary[monthScoreIndex].topCount += 1
                    } else {
                        var newMonthScore = MonthScore(id: UUID(), month: attemptedBoulder.boulder.month, topCount: 0.0)
                        newMonthScore.topCount += 1
                        summary.append(newMonthScore)
                    }
                }
            }
        }
        print("count \(count)")
        print("hardest \(hardest)")
        print(" average \(average)")
        return summary
    }
    
    func generateBarChartData() -> [(String, Double)] {
        var graphData = [(String, Double)]()
        for monthScore in self.generateSummary() {
            graphData.append((monthScore.month, monthScore.topCount))
        }
        return graphData
    }
}

struct MonthScore: Identifiable {
    var id: UUID
    var month: String
    var topCount: Double
}
