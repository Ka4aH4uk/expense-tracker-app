//
//  ExpenseData.swift
//  Expense Tracker
//

import Foundation

struct ExpenseData: Identifiable {
    var id = UUID()
    var date: Date
    var value: Double
}
