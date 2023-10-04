//
//  ChartView.swift
//  Expense Tracker
//

import SwiftUI
import Charts

struct ChartView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @ObservedObject private var viewModel = ChartViewModel()
    @State private var isLineGraph = false
    @State private var animationTrigger = false
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
                Text("График доходов и расходов - это как узнать, сколько стоит твоя жизнь каждый месяц")
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .padding()
                Spacer()
            } else {
                VStack {
                    HStack {
                        Text("График доходов и расходов")
                            .font(.title).bold()
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                    
                    CustomSegmentedControl(selectedInterval: $viewModel.selectedInterval, intervals: intervals, color: .blue)
                    .onChange(of: viewModel.selectedInterval) { _ in
                        viewModel.updateChartData()
                        animationTrigger = false
                        animateGraph(fromChange: true)
                    }
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    Spacer()
                    
                    HStack {
                        let totalProfitValue = viewModel.profitData.reduce(0.0) { partialResult, item in
                            item.value + partialResult
                        }
                        
                        let totalExpenseValue = viewModel.expenseData.reduce(0.0) { partialResult, item in
                            item.value + partialResult
                        }
                        
                        let totalValue = totalProfitValue - totalExpenseValue
                        
                        Text(totalValue.stringFormat + "\u{20BD}")
                            .font(.largeTitle.bold())
                            .padding(.horizontal,10)
                        Spacer()
                        
                        Toggle(isOn: $isLineGraph) {
                            HStack {
                                Spacer()
                                Image("linechart2")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.horizontal, 10)
                            }
                        }
                        .padding()
                    }
                    
                    Chart {
                        ForEach(viewModel.chartsData) { data in
                            RectangleMark(x: .value("Date", data.date),
                                          y: .value("Value", data.value),
                                          width: .fixed(3),
                                          height: .fixed(3)
                            )
                        }
                    }
                    .aspectRatio(4, contentMode: .fit)
                    .padding(.bottom).padding(.leading).padding(.trailing)
                    
                    AnimatedChartWithProfitAndExpenses()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                .padding()
            }
            Spacer()
        }
        .onAppear {
            viewModel.updateChartData()
        }
    }
    
    @ViewBuilder
    func AnimatedChartWithProfitAndExpenses() -> some View {
        let max = viewModel.chartsData.max { item1, item2 in
            return item2.value > item1.value
        }?.value ?? 0
        
        Chart {
            ForEach(viewModel.profitData) { data in
                if isLineGraph {
                    LineMark(
                        x: .value("Date Profit", data.date, unit: .day),
                        y: .value("Profit", animationTrigger ? data.value : 0),
                        series: .value("profit", "A")
                    )
                    .foregroundStyle(Color.blue.gradient)
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 4, dash: [5]))
                    .symbol {
                        Circle()
                            .fill(.blue)
                            .frame(width: 8)
                    }
                } else {
                    BarMark(
                        x: .value("Date Profit", data.date, unit: .day),
                        y: .value("Profit", animationTrigger ? data.value : 0)
                    )
                    .foregroundStyle(Color.blue.gradient)
                    .position(by: .value("profit", data.value))
                }
            }
            
            ForEach(viewModel.expenseData) { data in
                if isLineGraph {
                    LineMark(
                        x: .value("Date Expense", data.date, unit: .day),
                        y: .value("Expense", animationTrigger ? data.value : 0),
                        series: .value("expense", "B")
                    )
                    .lineStyle(.init(lineWidth: 5, lineCap: .round))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Color.red.gradient)
                    .symbol {
                        Circle()
                            .fill(.red)
                            .frame(width: 8)
                    }
                   
                    AreaMark(
                        x: .value("Date Expense", data.date, unit: .day),
                        y: .value("Expense", animationTrigger ? data.value : 0)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(isDarkMode ? Color.red.opacity(0.5).gradient : Color.red.opacity(0.1).gradient)
                } else {
                    BarMark(
                        x: .value("Date Expense", data.date, unit: .day),
                        y: .value("Expense", animationTrigger ? data.value : 0)
                    )
                    .foregroundStyle(Color.red.gradient)
                    .position(by: .value("expense", data.value))
                }
            }
        }
        .chartForegroundStyleScale([
            NSLocalizedString("Доходы", comment: ""): Color(.blue),
            NSLocalizedString("Расходы", comment: ""): Color(.red)
        ])
        .chartLegend(position: .bottom, alignment: .center)
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartYScale(domain: 0...(max + 2000))
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            animateGraph()
        }
    }
    
    private func animateGraph(fromChange: Bool = false) {
        for (index, _) in viewModel.chartsData.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animationTrigger = true
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .environmentObject(TabBarRouter())
    }
}
