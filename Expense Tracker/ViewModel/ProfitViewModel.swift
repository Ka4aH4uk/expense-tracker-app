//
//  ProfitViewModel.swift
//  Expense Tracker
//

import Foundation

final class ProfitViewModel: ObservableObject {
    @Published var balance: Double = 0.0
    @Published var profitCategories: [String: [Profit]] = [:]
    @Published var expandedSections: Set<String> = []

    init() {
        self.balance = UserDefaults.standard.double(forKey: "balance")
        if let data = UserDefaults.standard.data(forKey: "profitCategories"),
           let categories = try? JSONDecoder().decode([Profit].self, from: data) {
            let groupedCategories = Dictionary(grouping: categories) { $0.month }
            self.profitCategories = groupedCategories
            self.expandedSections = Set(groupedCategories.keys)
        }
    }

    func addProfit(amount: Double, date: Date) {
        let profit = Profit(amount: amount, date: date)
        balance += amount
        let month = profit.month

        if profitCategories[month] == nil {
            profitCategories[month] = []
        }

        profitCategories[month]?.append(profit)

        UserDefaults.standard.set(balance, forKey: "balance")

        let allProfits = profitCategories.values.flatMap { $0 }
        if let encoded = try? JSONEncoder().encode(allProfits) {
            UserDefaults.standard.set(encoded, forKey: "profitCategories")
        }
    }
}
