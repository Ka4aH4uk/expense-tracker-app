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
            let interval = selectedInterval
            let date = expense.date
            let currentDate = Date()

            switch interval {
            case .week:
                return date >= Calendar.current.date(byAdding: .day, value: -7, to: currentDate)! && date <= currentDate
            case .month:
                let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
                let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)!
                return date >= startDate && date < endDate
            case .quarter:
                let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
                let endDate = Calendar.current.date(byAdding: .month, value: 3, to: startDate)!
                return date >= startDate && date < endDate
            default:
                return true
            }
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
