//
//  Profit.swift
//  Expense Tracker
//

import Foundation

struct Profit: Codable, Identifiable {
    var id = UUID()
    var amount: Double
    var date: Date

    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
