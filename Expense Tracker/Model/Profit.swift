//
//  Profit.swift
//  Expense Tracker
//

import Foundation

struct Profit: Codable, Identifiable {
    var id = UUID()
    var amount: Double
    var date: Date
}
