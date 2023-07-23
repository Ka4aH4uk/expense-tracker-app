//
//  ChartView.swift
//  Expense Tracker
//

import SwiftUI
import Charts

struct ChartView: View {
    @EnvironmentObject var router: TabBarRouter
    @ObservedObject private var viewModel = ChartViewModel()
    let intervals: [Interval] = [.week, .month, .quarter, .all]
    
    var body: some View {
        VStack {
            Spacer()
            
            if viewModel.chartsData.isEmpty {
                Image("chart")
                    .resizable()
                    .scaledToFit()
                Text("График доходов и расходов -\n это как узнать, сколько стоит твоя жизнь каждый месяц")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding()
                Spacer()
            } else {
                Picker(selection: $viewModel.selectedInterval, label: Text("Выберите интервал")) {
                    ForEach(intervals, id: \.self) { interval in
                        Text(viewModel.intervalToString(interval))
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .onChange(of: viewModel.selectedInterval) { _ in
                    viewModel.updateChartData()
                }
                
                GroupBox ("График доходов и расходов") {
                    Chart {
                        ForEach(viewModel.expenseData) { data in
                            LineMark(
                                x: .value("Date Expense", data.date),
                                y: .value("Expense", data.value)
                            )
                            .interpolationMethod(.cardinal)
                            .foregroundStyle(by: .value("Expense", "Расходы"))
                            .lineStyle(.init(lineWidth: 5))
                            .symbol {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 8)
                                    .shadow(radius: 2)
                            }
                            
                            AreaMark(
                                x: .value("Date Expense", data.date),
                                y: .value("Expense", data.value)
                            )
                            .interpolationMethod(.cardinal)
                            .foregroundStyle(
                                .linearGradient(colors: [Color(.red).opacity(0.5),
                                                         Color(.orange).opacity(0.3)],
                                                startPoint: .top,
                                                endPoint: .bottom)
                            )
                        }
                        
                        ForEach(viewModel.profitData) { data in
                            LineMark(
                                x: .value("Date Profit", data.date),
                                y: .value("Profit", data.value)
                            )
                            .interpolationMethod(.cardinal)
                            .foregroundStyle(by: .value("Profit", "Доходы"))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [2]))
                            .symbol {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 8)
                                    .shadow(radius: 2)
                            }
                        }
                    }
                    .chartForegroundStyleScale([
                        "Доходы": Color(.blue),
                        "Расходы": Color(.red)
                    ])
                    .chartLegend(position: .bottom, alignment: .center)
                    .chartBackground { chartProxy in
                        Color.green.opacity(0.1)
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading, values: .automatic(desiredCount: 8))
                    }
                    .frame(height: 500)
                }
                .padding(10)
            }
            Spacer()
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .environmentObject(TabBarRouter())
    }
}
