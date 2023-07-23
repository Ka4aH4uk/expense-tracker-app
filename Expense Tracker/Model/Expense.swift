//
//  Expense.swift
//  Expense Tracker
//

import Foundation

struct Expense: Codable, Identifiable {
    var id = UUID()
    let name: String
    let amount: Double
    let date: Date
}
