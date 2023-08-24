//
//  ChartsData.swift
//  Expense Tracker
//

import Foundation

struct ChartsData: Codable, Identifiable {
    var id = UUID()
    let date: Date
    var value: Double
}
