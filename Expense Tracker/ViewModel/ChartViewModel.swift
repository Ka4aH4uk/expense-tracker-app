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
        if let savedExpenses = UserDefaults.standard.data(forKey: "allExpenses"), let loadedExpenses = try? JSONDecoder().decode([Expense].self, from: savedExpenses) {
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
        let chartsData = sortedExpenses.map { expense in
            ChartsData(date: expense.date, value: expense.amount)
        }
        return chartsData
    }
    
    private func getFilteredProfits() -> [ChartsData] {
        let filteredProfits = profitCategories.filter { profit in
            let interval = selectedInterval
            let date = profit.date
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

    func intervalToString(_ interval: Interval) -> String {
        switch interval {
        case .week:
            return "Неделя"
        case .month:
            return "Месяц"
        case .quarter:
            return "Квартал"
        case .all:
            return "Все время"
        }
    }
}
