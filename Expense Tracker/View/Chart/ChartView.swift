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
                Text("График доходов и расходов -\n это как узнать, сколько стоит твоя жизнь каждый месяц")
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .padding()
                Spacer()
            } else {
                NavigationStack {
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
                    
                    AnimatedChartWithProfitAndExpenses()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .navigationTitle("График доходов и расходов")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .padding(10)
            }
            Spacer()
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
                        y: .value("Profit", animationTrigger ? data.value : 0)
                    )
                    .lineStyle(.init(lineWidth: 5, lineCap: .round))
                    .foregroundStyle(Color.blue.gradient)
                    .interpolationMethod(.catmullRom)
                   
                    AreaMark(
                        x: .value("Date Profit", data.date, unit: .day),
                        y: .value("Profit", animationTrigger ? data.value : 0)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(isDarkMode ? Color.blue.opacity(0.5).gradient : Color.blue.opacity(0.1).gradient)
                } else {
                    BarMark(
                        x: .value("Date Profit", data.date, unit: .day),
                        y: .value("Profit", animationTrigger ? data.value : 0)
                    )
                    .foregroundStyle(Color.blue.gradient)
                }
            }
            
            ForEach(viewModel.expenseData) { data in
                if isLineGraph {
                    LineMark(
                        x: .value("Date Expense", data.date, unit: .day),
                        y: .value("Expense", animationTrigger ? data.value : 0)
                    )
                    .lineStyle(.init(lineWidth: 5, lineCap: .round))
                    .foregroundStyle(Color.red.gradient)
                    .interpolationMethod(.catmullRom)
                   
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
                }
            }
        }
        .chartForegroundStyleScale([
            "Доходы": Color(.blue),
            "Расходы": Color(.red)
        ])
        .chartLegend(position: .bottom, alignment: .center)
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartYScale(domain: 0...(max + 5000))
        .frame(height: 500)
        .onAppear {
            viewModel.updateChartData()
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
