//
//  ExpenseData.swift
//  Expense Tracker
//

import Foundation

struct ExpenseData: Identifiable {
    var id = UUID()
    let date: Date
    let value: Double
}
