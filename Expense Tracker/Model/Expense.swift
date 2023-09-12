//
//  Expense.swift
//  Expense Tracker
//

import Foundation

struct Expense: Codable, Identifiable {
    var id = UUID()
    var name: String
    var amount: Double
    var date: Date
}
