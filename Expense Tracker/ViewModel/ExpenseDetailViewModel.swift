//
//  ExpenseDetailViewModel.swift
//  Expense Tracker
//

import SwiftUI

final class ExpenseDetailViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var allExpenses: [Expense] = []
    let category: ExpenseCategory

    init(category: ExpenseCategory) {
        self.category = category
        loadExpenses()
    }
    
    private func loadExpenses() {
        let defaults = UserDefaults.standard
        if let savedExpenses = defaults.data(forKey: category.name) {
            if let loadedExpenses = try? JSONDecoder().decode([Expense].self, from: savedExpenses) {
                expenses = loadedExpenses
            }
        }
        
        if let savedAllExpenses = defaults.data(forKey: "allExpenses") {
            if let loadedAllExpenses = try? JSONDecoder().decode([Expense].self, from: savedAllExpenses) {
                allExpenses = loadedAllExpenses
            }
        }
    }
    
    func addExpense(name: String, amount: Double, date: Date) {
        let expense = Expense(name: name, amount: amount, date: date)
        expenses.append(expense)
        saveExpenses()
        allExpenses.append(expense)
        saveAllExpenses()
    }
    
    private func saveExpenses() {
        do {
            let data = try JSONEncoder().encode(expenses)
            UserDefaults.standard.set(data, forKey: category.name)
        } catch {
            print("Failed to save expenses: \(error.localizedDescription)")
        }
    }
    
    private func saveAllExpenses() {
        do {
            let data = try JSONEncoder().encode(allExpenses)
            UserDefaults.standard.set(data, forKey: "allExpenses")
        } catch {
            print("Failed to save all expenses: \(error.localizedDescription)")
        }
    }
}
