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
            return NSLocalizedString("Неделя", comment: "")
        case .month:
            return NSLocalizedString("Месяц", comment: "")
        case .quarter:
            return NSLocalizedString("Квартал", comment: "")
        case .all:
            return NSLocalizedString("Все время", comment: "")
        }
    }
}
