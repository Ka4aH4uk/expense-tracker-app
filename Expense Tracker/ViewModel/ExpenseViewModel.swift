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
        if let savedCategories = UserDefaults.standard.data(forKey: "ExpenseCategories") {
            if let decodedCategories = try? JSONDecoder().decode([ExpenseCategory].self, from: savedCategories) {
                expenseCategories = decodedCategories
            }
        }
    }
    
    func saveCategories() {
        if let encodedCategories = try? JSONEncoder().encode(expenseCategories) {
            UserDefaults.standard.set(encodedCategories, forKey: "ExpenseCategories")
        }
    }
    
    func addCategory(name: String) {
        let newCategory = ExpenseCategory(name: name)
        expenseCategories.append(newCategory)
        saveCategories()
    }
}
