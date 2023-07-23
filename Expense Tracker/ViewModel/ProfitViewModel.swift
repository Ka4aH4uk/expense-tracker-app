//
//  ProfitViewModel.swift
//  Expense Tracker
//

import Foundation

class ProfitViewModel: ObservableObject {
    @Published var balance: Double = 0.0
    @Published var profitCategories: [Profit] = []

    // Инициализация вьюмодели
    init() {
        self.balance = UserDefaults.standard.double(forKey: "balance")
        if let data = UserDefaults.standard.data(forKey: "profitCategories"),
           let categories = try? JSONDecoder().decode([Profit].self, from: data) {
            self.profitCategories = categories
        }
    }

    // Метод добавления дохода
    func addProfit(amount: Double, date: Date) {
        let profit = Profit(amount: amount, date: date)
        balance += amount
        profitCategories.append(profit)
        UserDefaults.standard.set(balance, forKey: "balance")
        if let encoded = try? JSONEncoder().encode(profitCategories) {
            UserDefaults.standard.set(encoded, forKey: "profitCategories")
        }
    }
}
