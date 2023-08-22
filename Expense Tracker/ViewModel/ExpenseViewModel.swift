//
//  ExpenseViewModel.swift
//  Expense Tracker
//

import SwiftUI

class ExpenseViewModel: ObservableObject {
    @Published var expenseCategories = [ExpenseCategory]()
    
    init() {
        loadCategories()
    }
    
    private func loadCategories() {
        if let savedCategoriesData = UserDefaults.standard.data(forKey: "ExpenseCategories") {
            if var decodedCategories = try? JSONDecoder().decode([ExpenseCategory].self, from: savedCategoriesData) {
                for index in 0..<decodedCategories.count {
                    let categoryName = decodedCategories[index].name
                    let expenses = loadExpenses(for: categoryName)
                    decodedCategories[index].expenses = expenses
                }
                expenseCategories = decodedCategories
            }
        }
    }

    private func loadExpenses(for categoryName: String) -> [Expense] {
        if let savedExpensesData = UserDefaults.standard.data(forKey: categoryName) {
            if let loadedExpenses = try? JSONDecoder().decode([Expense].self, from: savedExpensesData) {
                return loadedExpenses
            }
        }
        return []
    }
    
    func saveCategories() {
        if let encodedCategories = try? JSONEncoder().encode(expenseCategories) {
            UserDefaults.standard.set(encodedCategories, forKey: "ExpenseCategories")
        }
    }
    
    func addCategory(name: String, iconName: String?) {
        let newCategory = ExpenseCategory(name: name, iconName: iconName)
        expenseCategories.append(newCategory)
        saveCategories()
    }
}
