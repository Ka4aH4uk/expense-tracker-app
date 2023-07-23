//
//  Profit.swift
//  Expense Tracker
//

import Foundation

struct Profit: Codable, Identifiable {
    var id = UUID()
    let amount: Double
    let date: Date
}
