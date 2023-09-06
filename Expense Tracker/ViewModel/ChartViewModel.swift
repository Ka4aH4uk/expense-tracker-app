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
        
        let sortedExpenses = filteredExpenses.sorted(by: { $0.date < $1.date })
        let chartsData = sortedExpenses.map { expense in
            ChartsData(date: expense.date, value: expense.amount)
        }
        
        return chartsData
    }
    
    private func getFilteredProfits() -> [ChartsData] {
        let filteredProfits = profitCategories.filter { profit in
            let date = profit.date
            return isDateInRange(date, selectedInterval: selectedInterval)
        }
        
        let sortedExpenses = filteredProfits.sorted(by: { $0.date < $1.date })
        let chartsData = sortedExpenses.map { profit in
            ChartsData(date: profit.date, value: profit.amount)
        }
        
        return chartsData
    }
    
    func updateChartData() {
        expenseData = getFilteredExpenses()
        profitData = getFilteredProfits()
        chartsData = expenseData + profitData
    }
}
