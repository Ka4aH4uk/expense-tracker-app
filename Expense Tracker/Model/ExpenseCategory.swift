//
//  ExpenseCategory.swift
//  Expense Tracker
//

import Foundation

struct ExpenseCategory: Codable, Identifiable {
    var id = UUID()
    var name: String
    var expenses: [Expense] = []
    var iconName: String?

    var numberOfExpenses: Int {
        expenses.count
    }
}
