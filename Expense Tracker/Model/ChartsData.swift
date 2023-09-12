//
//  ChartsData.swift
//  Expense Tracker
//

import Foundation

struct ChartsData: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var value: Double
}
