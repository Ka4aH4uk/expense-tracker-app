//
//  UI Components.swift
//  Expense Tracker
//

import SwiftUI

struct ClearButton: ViewModifier {
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
