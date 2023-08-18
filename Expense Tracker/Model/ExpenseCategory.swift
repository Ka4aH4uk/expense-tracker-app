//
//  ExpenseCategory.swift
//  Expense Tracker
//

import Foundation

struct ExpenseCategory: Codable, Identifiable {
    var id = UUID()
    let name: String
    var expenses: [Expense] = []

    var numberOfExpenses: Int {
        expenses.count
    }
}
