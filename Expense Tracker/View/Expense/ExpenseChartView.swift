//
//  ExpenseChartView.swift
//  Expense Tracker
//

import SwiftUI
import Charts

struct ExpenseChartView: View {
    @Binding var showExpenseChart: Bool
    @ObservedObject private var viewModel: ExpenseChartViewModel
    @State private var selectedInterval = Interval.week
    @Environment(\.dismiss) private var dismiss
    
    let intervals: [Interval] = [.week, .month, .quarter, .all]
    
    init(category: ExpenseCategory, showExpenseChart: Binding<Bool>) {
        self._showExpenseChart = showExpenseChart
        _viewModel = ObservedObject(wrappedValue: ExpenseChartViewModel(category: category))
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            if viewModel.dataChart.isEmpty {
                Image("chart2")
                    .resizable()
                    .scaledToFit()
                Text("Этот график покажет, насколько успешно\n Вы продолжаете бороться с соблазнами тратить\n все свои деньги на ненужные вещи")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            } else {
                Picker(selection: $selectedInterval, label: Text("Выберите интервал")) {
                    ForEach(intervals, id: \.self) { interval in
                        Text(viewModel.intervalToString(interval))
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .onChange(of: selectedInterval) { _ in
                    viewModel.dataChart = viewModel.getFilteredExpenses()
                }
                
                GroupBox ("\(viewModel.category.name): график расходов") {
                    Chart {
                        ForEach(viewModel.dataChart) { data in
                            LineMark(
                                x: .value("Интервал", data.date),
                                y: .value("Сумма", data.value)
                            )
                            .interpolationMethod(.cardinal)
                            .foregroundStyle(.red)
                            .lineStyle(.init(lineWidth: 5))
                            .symbol {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 8)
                                    .shadow(radius: 2)
                            }
                            
                            AreaMark(
                                x: .value("Интервал", data.date),
                                y: .value("Сумма", data.value)
                            )
                            .interpolationMethod(.cardinal)
                            .foregroundStyle(
                                .linearGradient(colors: [Color(.red).opacity(0.5),
                                                         Color(.orange).opacity(0.3)],
                                                startPoint: .top,
                                                endPoint: .bottom)
                            )
                        }
                    }
                    .chartBackground { chartProxy in
                        Color.red.opacity(0.1)
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
}

struct ExpenseChartView_Previews: PreviewProvider {
    static var previews: some View {
        let category = ExpenseCategory(name: "Категория")
        let dataChart: [ExpenseData] = [
            ExpenseData(date: Date(), value: 50.0),
            ExpenseData(date: Date().addingTimeInterval(86400), value: 75.0),
            ExpenseData(date: Date().addingTimeInterval(2 * 86400), value: 100.0)
        ]
        let viewModel = ExpenseChartViewModel(category: category)
        viewModel.dataChart = dataChart
        
        return ExpenseChartView(category: category, showExpenseChart: .constant(true))
            .environmentObject(viewModel)
    }
}

//struct ExpenseChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        let category = ExpenseCategory(name: "")
//        ExpenseChartView(category: category, showExpenseChart: .constant(true))
//    }
//}
