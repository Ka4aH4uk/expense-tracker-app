//
//  ChartViewModel.swift
//  Expense Tracker
//

import SwiftUI

class ChartViewModel: ObservableObject {
    @Published var chartsData: [ChartsData] = []
    @Published var profitCategories: [Profit] = []
    @Published var expenses: [Expense] = []
    @Published var expenseData: [ChartsData] = []
    @Published var profitData: [ChartsData] = []
    @Published var selectedInterval: Interval = .week
    @Published var intervals: [Interval] = [.week, .month, .quarter, .all]

    
    init() {
        loadExpenses()
        loadProfits()
        updateChartData()
    }
    
    private func loadExpenses() {
        if let savedExpenses = UserDefaults.standard.data(forKey: "allExpenses"),
           let loadedExpenses = try? JSONDecoder().decode([Expense].self, from: savedExpenses) {
            self.expenses = loadedExpenses
        }
    }
    
    private func loadProfits() {
        if let savedProfits = UserDefaults.standard.data(forKey: "profitCategories"),
           let loadedProfits = try? JSONDecoder().decode([Profit].self, from: savedProfits) {
            self.profitCategories = loadedProfits
        }
    }
    
    private func getFilteredExpenses() -> [ChartsData] {
        let filteredExpenses = expenses.filter { expense in
            let date = expense.date
            return isDateInRange(date, selectedInterval: selectedInterval)
        }
        
        let groupedExpenses = Dictionary(grouping: filteredExpenses, by: { Calendar.current.startOfDay(for: $0.date) })
        
        var expenseData = [ChartsData]()
        for (date, expenses) in groupedExpenses.sorted(by: { $0.key < $1.key }) {
            let totalValue = expenses.reduce(0) { partialResult, item in
                item.amount + partialResult
            }
            expenseData.append(ChartsData(date: date, value: totalValue))
        }
        
        return expenseData
    }
    
    private func getFilteredProfits() -> [ChartsData] {
        let filteredProfits = profitCategories.filter { profit in
            let date = profit.date
            return isDateInRange(date, selectedInterval: selectedInterval)
        }
        
        let groupedProfits = Dictionary(grouping: filteredProfits, by: { Calendar.current.startOfDay(for: $0.date) })
        
        var profitsData = [ChartsData]()
        for (date, profits) in groupedProfits.sorted(by: { $0.key < $1.key }) {
            let totalValue = profits.reduce(0) { partialResult, item in
                item.amount + partialResult
            }
            profitsData.append(ChartsData(date: date, value: totalValue))
        }
        
        return profitsData
    }
    
    func updateChartData() {
        expenseData = getFilteredExpenses()
        profitData = getFilteredProfits()
        chartsData = expenseData + profitData
    }
}
