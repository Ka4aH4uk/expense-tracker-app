//
//  ExpenseChartViewModel.swift
//  Expense Tracker
//

import SwiftUI

class ExpenseChartViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var dataChart: [ExpenseData] = []
    @Published var selectedInterval: Interval = .week
    
    let category: ExpenseCategory
    
    init(category: ExpenseCategory) {
        self.category = category
        loadExpenses()
        updateChartData()
    }
    
    private func loadExpenses() {
        let defaults = UserDefaults.standard
        if let savedExpenses = defaults.object(forKey: category.name) as? Data {
            if let loadedExpenses = try? JSONDecoder().decode([Expense].self, from: savedExpenses) {
                expenses = loadedExpenses
            }
        }
    }
    
    func updateChartData() {
        let filteredExpenses = getFilteredExpenses()
        self.dataChart = filteredExpenses
    }
    
    func getFilteredExpenses() -> [ExpenseData] {
        let filteredExpenses = expenses.filter { expense in
            let date = expense.date
            return isDateInRange(date, selectedInterval: selectedInterval)
        }
        
        let sortedExpenses = filteredExpenses.sorted(by: { $0.date < $1.date })
        let expenseData = sortedExpenses.map { expense in
            ExpenseData(date: expense.date, value: expense.amount)
        }
        return expenseData
    }
}
