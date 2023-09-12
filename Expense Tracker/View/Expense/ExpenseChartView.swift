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
                
                Text("Этот график покажет, насколько успешно\n Вы продолжаете бороться с соблазнами тратить\n все свои деньги на ненужные вещи")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            } else {
                Divider()
                    .padding(.horizontal, 10)
                
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
                        .padding(.top)
                    }
                    
                    AnimatedChart()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(isDarkMode ? Color.black : Color.white)
                        .shadow(color: Color.gray, radius: 2)
                }
                .padding(10)
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
    func AnimatedChart() -> some View {
        let max = viewModel.dataChart.max { item1, item2 in
            return item2.value > item1.value
        }?.value ?? 0
        
        Chart {
            ForEach(viewModel.dataChart) { data in
                if isLineGraph {
                    LineMark(
                        x: .value("Интервал", data.date, unit: .day),
                        y: .value("Сумма", animationTrigger ? data.value : 0)
                    )
                    .foregroundStyle(Color.red.gradient)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Интервал", data.date, unit: .day),
                        y: .value("Сумма", animationTrigger ? data.value : 0)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Color.red.opacity(0.1).gradient)

//                    .foregroundStyle(
//                        .linearGradient(colors: [Color(.red).opacity(0.5),
//                                                 Color(.orange).opacity(0.3)],
//                                        startPoint: .top,
//                                        endPoint: .bottom)
//                    )
                } else {
                    BarMark(
                        x: .value("Интервал", data.date, unit: .day),
                        y: .value("Сумма", animationTrigger ? data.value : 0)
                    )
                    .foregroundStyle(Color.red.gradient)
                }
                
                if let currentActiveItem, currentActiveItem.id == data.id {
                    RuleMark(x: .value("Интервал", currentActiveItem.date))
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                        .offset(x: (plotWidth / CGFloat(viewModel.dataChart.count / 2))) //
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
            AxisMarks(position: .leading, values: .automatic(desiredCount: 6))
        }
        .chartYScale(domain: 0...(max + 2500))
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
                                    let day = calendar.component(.day, from: date)
                                    if let currentItem = viewModel.dataChart.first(where: { item in
                                        calendar.component(.day, from: item.date) == day
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
    
    func animateGraph(fromChange: Bool = false) {
        for (index, _) in viewModel.dataChart.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    animationTrigger = true
                }
            }
        }
    }
}

//struct ExpenseChartView: View {
//    @Binding var showExpenseChart: Bool
//    @ObservedObject private var viewModel: ExpenseChartViewModel
//    @State private var selectedInterval = Interval.week
//    @Environment(\.dismiss) private var dismiss
//
//    let intervals: [Interval] = [.week, .month, .quarter, .all]
//
//    init(category: ExpenseCategory, showExpenseChart: Binding<Bool>) {
//        self._showExpenseChart = showExpenseChart
//        _viewModel = ObservedObject(wrappedValue: ExpenseChartViewModel(category: category))
//    }
//
//    var body: some View {
//        VStack {
//            Spacer()
//
//            if !viewModel.dataChart.isEmpty {
//                Spacer()
//                LottieView(name: "chart2", loopMode: .loop, animationSpeed: 0.5)
//                    .scaleEffect(0.2)
//                    .frame(height: 200)
//                    .padding()
//
//                Text("Этот график покажет, насколько успешно\n Вы продолжаете бороться с соблазнами тратить\n все свои деньги на ненужные вещи")
//                    .font(.body)
//                    .multilineTextAlignment(.center)
//                    .padding()
//                Spacer()
//            } else {
//                GroupBox ("График расходов") {
//                    Divider()
//                    Spacer()
//                    HStack {
//                        Text("Выберите интервал")
//                            .font(.callout)
//                            .multilineTextAlignment(.center)
//                            Image(systemName: "calendar")
//                    }
//                    .padding(5)
//
//                    CustomSegmentedControl(selectedInterval: $selectedInterval, intervals: intervals, color: .red)
//                    .onChange(of: selectedInterval) { newValue in
//                        viewModel.selectedInterval = newValue
//                        viewModel.updateChartData()
//                    }
//                    .padding(.bottom, 10)
//                    Divider()
//                    Spacer()
//
//                    Chart {
//                        ForEach(viewModel.dataChart) { data in
//                            LineMark(
//                                x: .value("Интервал", data.date),
//                                y: .value("Сумма", data.value)
//                            )
//                            .interpolationMethod(.cardinal)
//                            .foregroundStyle(.red)
//                            .lineStyle(.init(lineWidth: 5))
//                            .symbol {
//                                Circle()
//                                    .fill(.red)
//                                    .frame(width: 8)
//                                    .shadow(radius: 2)
//                            }
//
//                            AreaMark(
//                                x: .value("Интервал", data.date),
//                                y: .value("Сумма", data.value)
//                            )
//                            .interpolationMethod(.cardinal)
//                            .foregroundStyle(
//                                .linearGradient(colors: [Color(.red).opacity(0.5),
//                                                         Color(.orange).opacity(0.3)],
//                                                startPoint: .top,
//                                                endPoint: .bottom)
//                            )
//                        }
//                    }
//                    .chartBackground { chartProxy in
//                        Color.red.opacity(0.1)
//                    }
//                    .chartYAxis {
//                        AxisMarks(position: .leading, values: .automatic(desiredCount: 8))
//                    }
//                    .frame(height: 500)
//                }
//                .background(
//                    Rectangle()
//                        .fill(Color.white)
//                        .cornerRadius(12)
//                        .shadow(
//                            color: Color.gray.opacity(0.7),
//                            radius: 6,
//                            x: 0,
//                            y: 0
//                        )
//                )
//                .padding(10)
//            }
//            Spacer()
//        }
//        .navigationBarTitle("\(viewModel.category.name)")
//        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button {
//                    dismiss()
//                } label: {
//                    HStack {
//                        Image(systemName: "chevron.backward")
//                    }
//                }
//            }
//        }
//        .onAppear {
//            viewModel.updateChartData()
//        }
//    }
//}

struct ExpenseChartView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseChartView(category: ExpenseCategory(name: ""), showExpenseChart: .constant(true))
            .previewLayout(.fixed(width: 400, height: 600))
    }
}
