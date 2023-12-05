//
//  ExpenseViewModel.swift
//  Expense Tracker
//

import SwiftUI

final class ExpenseViewModel: ObservableObject {
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
        // Сохраняем все расходы при каждом сохранении категорий
        saveAllExpenses()
    }
    
    func addCategory(name: String, iconName: String?) {
        let newCategory = ExpenseCategory(name: name, iconName: iconName)
        expenseCategories.append(newCategory)
        saveCategories()
    }
    
    func deleteCategory(at indexSet: IndexSet) {
        for index in indexSet {
            let category = expenseCategories[index]
            deleteExpenses(for: category)
            expenseCategories.remove(at: index)
        }
        saveCategories()
    }
    
    private func deleteExpenses(for category: ExpenseCategory) {
        UserDefaults.standard.removeObject(forKey: category.name)
        saveExpenses()
    }
    
    func saveExpenses() {
        if let encodedExpenses = try? JSONEncoder().encode(allExpenses()) {
            UserDefaults.standard.set(encodedExpenses, forKey: "allExpenses")
        }
    }
    
    private func saveAllExpenses() {
        if let encodedExpenses = try? JSONEncoder().encode(allExpenses()) {
            UserDefaults.standard.set(encodedExpenses, forKey: "allExpenses")
        }
    }
    
    private func allExpenses() -> [Expense] {
        var allExpenses = [Expense]()
        for category in expenseCategories {
            allExpenses.append(contentsOf: category.expenses)
        }
        return allExpenses
    }
}
