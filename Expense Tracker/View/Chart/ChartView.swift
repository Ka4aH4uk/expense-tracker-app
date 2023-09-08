//
//  ChartView.swift
//  Expense Tracker
//

import SwiftUI
import Charts

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
                    
                    CustomSegmentedControl(selectedInterval: $viewModel.selectedInterval, intervals: intervals, color: .blue)
                    .onChange(of: viewModel.selectedInterval) { _ in
                        viewModel.updateChartData()
                    }
                    .padding(.bottom, 10)
                    Divider()
                    Spacer()
                    
                    ChartWithProfitAndExpensesView(viewModel: viewModel)
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

struct ChartWithProfitAndExpensesView: View {
    @ObservedObject var viewModel: ChartViewModel

    var body: some View {
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
}

//struct ChartCustomSegmentedControl: View {
//    @Binding var selectedInterval: Interval
//    let intervals: [Interval]
//    let color = Color.blue
//
//    var body: some View {
//        HStack(spacing: 5) {
//            ForEach(intervals.indices, id:\.self) { index in
//                Button(action: {
//                    selectedInterval = intervals[index]
//                }) {
//                    Text(Interval.intervalToString(intervals[index]))
//                        .font(.system(size: 14))
//                        .padding(.vertical, 10)
//                        .padding(.horizontal, 20)
//                        .background(color.opacity(0.8))
//                        .cornerRadius(10)
//                        .lineLimit(1)
//                }
//                .foregroundColor(.white)
//                .opacity(selectedInterval == intervals[index] ? 1 : 0.5)
//            }
//        }
//    }
//}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .environmentObject(TabBarRouter())
    }
}
