//
//  ExpenseChartView.swift
//  Expense Tracker
//

import SwiftUI
import Charts

struct ExpenseChartView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @Binding var showExpenseChart: Bool
    @ObservedObject private var viewModel: ExpenseChartViewModel
    @State private var selectedInterval = Interval.week
    @State private var animationTrigger = false
    @State private var isLineGraph = false
    @State var currentActiveItem: ExpenseData?
    @State var plotWidth: CGFloat = 0
    @Environment(\.dismiss) private var dismiss
    
    let intervals: [Interval] = [.week, .month, .quarter, .all]
    
    init(category: ExpenseCategory, showExpenseChart: Binding<Bool>) {
        self._showExpenseChart = showExpenseChart
        _viewModel = ObservedObject(wrappedValue: ExpenseChartViewModel(category: category))
    }
    
    var body: some View {
        VStack {
            if viewModel.dataChart.isEmpty {
                Spacer()
                Spacer()
                LottieView(name: "chart2", loopMode: .loop, animationSpeed: 0.5)
                    .scaleEffect(0.2)
                    .frame(height: 200)
                    .padding()
                
                Text("Этот график покажет, насколько успешно Вы продолжаете бороться с соблазнами тратить все свои деньги на ненужные вещи")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            } else {                
                VStack {
                    Spacer()
                    
                    CustomSegmentedControl(selectedInterval: $selectedInterval, intervals: intervals, color: .red)
                        .onChange(of: selectedInterval) { newValue in
                            viewModel.selectedInterval = newValue
                            viewModel.updateChartData()
                            animationTrigger = false
                            animateGraph(fromChange: true)
                        }
                        .padding(.bottom, 10)
                    Spacer()
                    
                    HStack {
                        let totalValue = viewModel.dataChart.reduce(0.0) { partialResult, item in
                            item.value + partialResult
                        }
                        
                        Text(totalValue.stringFormat + "\u{20BD}")
                            .font(.largeTitle.bold())
                            .padding(.horizontal,10)
                        Spacer()
                        
                        Toggle(isOn: $isLineGraph) {
                            HStack {
                                Spacer()
                                Image("linechart")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(.horizontal, 10)
                            }
                        }
                        .padding()
                    }
                    
                    AnimatedChartExpenses()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                .padding()
            }
            Spacer()
        }
        .navigationBarTitle("\(viewModel.category.name)")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                    }
                }
            }
        }
        .onAppear {
            viewModel.updateChartData()
        }
    }
    
    @ViewBuilder
    func AnimatedChartExpenses() -> some View {
        let max = viewModel.dataChart.max { item1, item2 in
            return item2.value > item1.value
        }?.value ?? 0
        
        Chart {
            ForEach(viewModel.dataChart) { data in
                if isLineGraph {
                    LineMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value("Expense", animationTrigger ? data.value : 0)
                    )
                    .lineStyle(.init(lineWidth: 5, lineCap: .round))
                    .foregroundStyle(Color.red.gradient)
                    .interpolationMethod(.catmullRom)
                   
                    AreaMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value("Expense", animationTrigger ? data.value : 0)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(isDarkMode ? Color.red.opacity(0.5).gradient : Color.red.opacity(0.1).gradient)
                } else {
                    BarMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value("Expense", animationTrigger ? data.value : 0)
                    )
                    .foregroundStyle(Color.red.gradient)
                }
                
                if let currentActiveItem, currentActiveItem.id == data.id {
                    RuleMark(x: .value("Date", currentActiveItem.date))
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                        .offset(x: (plotWidth / CGFloat(viewModel.dataChart.count)) / 2)
                        .annotation(position: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Сумма")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(currentActiveItem.value.stringFormat + "\u{20BD}")
                                    .font(.title3.bold())
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(.white.shadow(.drop(radius: 2)))
                            }
                        }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartYScale(domain: 0...(max + 2000))
        .chartOverlay(content: { proxy in
            GeometryReader { innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let location = value.location
                                if let date: Date = proxy.value(atX: location.x) {
                                    let calendar = Calendar.current
                                    if let currentItem = viewModel.dataChart.first(where: { item in
                                       calendar.isDate(item.date, inSameDayAs: date)
                                    }) {
                                        self.currentActiveItem = currentItem
                                        self.plotWidth = proxy.plotAreaSize.width
                                    }
                                }
                            }
                            .onEnded { value in
                                self.currentActiveItem = nil
                            }
                    )
            }
        })
        .frame(height: 500)
        .onAppear {
            animateGraph()
        }
    }
    
    private func animateGraph(fromChange: Bool = false) {
        for (index, _) in viewModel.dataChart.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animationTrigger = true
                }
            }
        }
    }
}

#Preview {
    ExpenseChartView(category: ExpenseCategory(name: "Category"), showExpenseChart: .constant(true))
}
