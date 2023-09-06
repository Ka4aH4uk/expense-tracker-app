//
//  Interval.swift
//  Expense Tracker
//

import Foundation

enum Interval {
    case week
    case month
    case quarter
    case all
    
    static func intervalToString(_ interval: Interval) -> String {
        switch interval {
        case .week:
            return "Неделя"
        case .month:
            return "Месяц"
        case .quarter:
            return "Квартал"
        case .all:
            return "Все время"
        }
    }
}
