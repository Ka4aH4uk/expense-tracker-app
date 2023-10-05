//
//  Extension.swift
//  Expense Tracker
//

import SwiftUI

extension DateFormatter {
    static let expenseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}

public struct ClearButton: ViewModifier {
    @Binding var text: String
    
    public func body(content: Content) -> some View {
        HStack {
            content
            Button(action: {
                self.text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
        }
    }
}

extension TextField {
    func floatingPlaceholder(_ title: String, text: Binding<String>) -> some View {
        let binding = Binding<String>(
            get: { text.wrappedValue },
            set: {
                text.wrappedValue = $0
            }
        )
        
        return self
            .font(.title2)
            .padding()
            .textFieldStyle(PlainTextFieldStyle())
            .overlay(Text(title)
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.horizontal, 15)
                .opacity(binding.wrappedValue.isEmpty ? 0.0 : 0.8)
                .offset(y: binding.wrappedValue.isEmpty ? 20 : 0), alignment: .topLeading)
            .modifier(ClearButton(text: binding))
            .padding(.trailing, 20)
    }
}

extension String {
    var decimalFormatted: String {
        return self.replacingOccurrences(of: ",", with: ".")
    }
}

extension Double {
    var stringFormat: String {
        if self >= 10000 && self < 999999 {
            return String(format: "%.1fK", self / 1000).replacingOccurrences(of: ".0", with: "")
        }
        
        if self > 999999 {
            return String(format: "%.1fM", self / 1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", self)
    }
}

extension ObservableObject {
    func isDateInRange(_ date: Date, selectedInterval: Interval) -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current

        switch selectedInterval {
        case .week:
            if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)),
               let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek) {
                return date >= startOfWeek && date < endOfWeek
            }
        case .month:
            if let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)),
               let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) {
                return date >= startOfMonth && date < endOfMonth
            }
        case .quarter:
            if let startOfQuarter = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)),
               let endOfQuarter = calendar.date(byAdding: .month, value: 3, to: startOfQuarter) {
                return date >= startOfQuarter && date < endOfQuarter
            }
        default:
            return true
        }
        
        return false
    }
}

struct CustomSegmentedControl: View {
    @Binding var selectedInterval: Interval
    let intervals: [Interval]
    let color: LinearGradient
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(intervals.indices, id:\.self) { index in
                let isSelected = selectedInterval == intervals[index]
                ZStack {
                    Rectangle()
                        .fill(color.opacity(0.2))
                    
                    Rectangle()
                        .fill(color.opacity(0.8))
                        .cornerRadius(20)
                        .padding(2)
                        .opacity(isSelected ? 1 : 0.01)
                        .onTapGesture {
                            selectedInterval = intervals[index]
                        }
                }
                .overlay(
                    Text(Interval.intervalToString(intervals[index]))
                        .font(.system(size: 14))
                        .fontWeight(isSelected ? .bold : .regular)
                        .foregroundColor(isSelected ? .white : .gray)
                )
            }
        }
        .frame(height: 50)
        .cornerRadius(20)
    }
}
