//
//  ExpenseChartViewModel.swift
//  Expense Tracker
//

import SwiftUI

final class ExpenseChartViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var dataChart: [ExpenseData] = []
    @Published var selectedInterval: Interval = .week
    @Published var isFirstVisit = true
    
    let category: ExpenseCategory
    
    init(category: ExpenseCategory) {
        self.category = category
        loadExpenses()
        updateChartData()
    }
    
    private func loadExpenses() {
        let defaults = UserDefaults.standard
        if let savedExpenses = defaults.object(forKey: category.name) as? Data {
            if let loadedExpenses = try? JSONDecoder().decode([Expense].self, from: savedExpenses),
               !loadedExpenses.isEmpty{
                expenses = loadedExpenses
                isFirstVisit = false
            }
        }
    }
    
    func updateChartData() {
        let filteredExpenses = getFilteredExpenses()
        
        if filteredExpenses.isEmpty && isFirstVisit {
            return self.dataChart = []
        } else {
            self.dataChart = filteredExpenses
        }
    }
    
    func getFilteredExpenses() -> [ExpenseData] {
        let filteredExpenses = expenses.filter { expense in
            let date = expense.date
            return isDateInRange(date, selectedInterval: selectedInterval)
        }
        
        let groupedExpenses = Dictionary(grouping: filteredExpenses, by: { Calendar.current.startOfDay(for: $0.date) })
        
        var expenseData = [ExpenseData]()
        for (date, expenses) in groupedExpenses.sorted(by: { $0.key < $1.key }) {
            let totalValue = expenses.reduce(0) { partialResult, item in
                item.amount + partialResult
            }
            expenseData.append(ExpenseData(date: date, value: totalValue))
        }
        
        return expenseData
    }
}
