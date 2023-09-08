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
                GroupBox ("График расходов") {
                    Divider()
                    Spacer()
                    HStack {
                        Text("Выберите интервал")
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            Image(systemName: "calendar")
                    }
                    .padding(5)
                    
                    CustomSegmentedControl(selectedInterval: $selectedInterval, intervals: intervals, color: .red)
                    .onChange(of: selectedInterval) { newValue in
                        viewModel.selectedInterval = newValue
                        viewModel.updateChartData()
                    }
                    .padding(.bottom, 10)
                    Divider()
                    Spacer()
                
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
}

struct ExpenseChartView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseChartView(category: ExpenseCategory(name: ""), showExpenseChart: .constant(true))
    }
}
