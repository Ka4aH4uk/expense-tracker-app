//
//  ChartView.swift
//  Expense Tracker
//

import SwiftUI
import Charts
import SwiftUIIntrospect

struct ChartView: View {
    @ObservedObject private var viewModel = ChartViewModel()
    let intervals: [Interval] = [.week, .month, .quarter, .all]
    
    var body: some View {
        VStack {
            Spacer()
            
            if viewModel.chartsData.isEmpty {
                Spacer()
                LottieView(name: "chart", loopMode: .loop)
                    .scaleEffect(0.5)
                    .frame(height: 180)
                    .padding()
//                Image("chart")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 300)
                Text("График доходов и расходов -\n это как узнать, сколько стоит твоя жизнь каждый месяц")
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .padding()
                Spacer()
            } else {
                GroupBox ("График доходов и расходов") {
                    Divider()
                    Spacer()
                    HStack {
                        Text("Выберите интервал")
                            .font(.callout)
                            .multilineTextAlignment(.center)
                        Image(systemName: "calendar")
                    }
                    .padding(5)
                    
                    Picker("Интервал", selection: $viewModel.selectedInterval) {
                        ForEach(intervals, id: \.self) { interval in
                            Text(viewModel.intervalToString(interval))
                        }
                    }
                    .introspect(.picker(style: .segmented), on: .iOS(.v16, .v17), customize: { segmentedControl in
                        segmentedControl.backgroundColor = .clear
                        segmentedControl.tintColor = .systemBlue.withAlphaComponent(0.8)
                        segmentedControl.selectedSegmentTintColor = .systemBlue.withAlphaComponent(0.8)
                        segmentedControl.setTitleTextAttributes([
                            NSAttributedString.Key.foregroundColor: UIColor.white
                        ], for: .selected)
                        segmentedControl.setTitleTextAttributes([
                            NSAttributedString.Key.foregroundColor: UIColor.systemBlue.withAlphaComponent(0.7)
                        ], for: .normal)
                    })
                    .pickerStyle(.segmented)
                    .onChange(of: viewModel.selectedInterval) { _ in
                        viewModel.updateChartData()
                    }
                    .padding(.bottom, 10)
                    Divider()
                    Spacer()
                    
                    Chart {
                        ForEach(viewModel.expenseData) { data in
                            LineMark(
                                x: .value("Date Expense", data.date),
                                y: .value("Expense", data.value)
                            )
                            .interpolationMethod(.catmullRom)
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
                            .interpolationMethod(.catmullRom)
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
                            .interpolationMethod(.catmullRom)
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
                .background(
                    Rectangle()
                        .fill(Color.white)
                        .cornerRadius(12)
                        .shadow(
                            color: Color.gray.opacity(0.7),
                            radius: 6,
                            x: 0,
                            y: 0
                        )
                )
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
