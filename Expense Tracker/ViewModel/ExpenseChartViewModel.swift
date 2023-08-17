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
            let currentDate = Date()
            let calendar = Calendar.current

            switch selectedInterval {
            case .week:
                if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)),
                   let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek) {
                    return date >= startOfWeek && date < endOfWeek
                }
            case .month:
                if let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)),
                   let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) {
                    return date >= startOfMonth && date < endOfMonth
                }
            case .quarter:
                if let startOfQuarter = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)),
                   let endOfQuarter = calendar.date(byAdding: .month, value: 3, to: startOfQuarter) {
                    return date >= startOfQuarter && date < endOfQuarter
                }
            case .all:
                if let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: currentDate)),
                   let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear) {
                    return date >= startOfYear && date < endOfYear
                }
            }
            
            return false
        }
        
        let sortedExpenses = filteredExpenses.sorted(by: { $0.date < $1.date })
        let expenseData = sortedExpenses.map { expense in
            ExpenseData(date: expense.date, value: expense.amount)
        }
        return expenseData
    }

    func intervalToString(_ interval: Interval) -> String {
        switch interval {
        case .week:
            return "Неделя"
        case .month:
            return "Месяц"
        case .quarter:
            return "Квартал"
        case .all:
            return "Всё время"
        }
    }
}
