//
//  ChartsData.swift
//  Expense Tracker
//

import Foundation

struct ChartsData: Identifiable {
    let id = UUID()
    let date: Date
    var value: Double
}
