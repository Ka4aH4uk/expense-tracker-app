//
//  Extension.swift
//  Expense Tracker
//

import Foundation
import SwiftUI

// кнопка очистки текстового поля
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

// формат даты dd.MM.yyyy
extension DateFormatter {
    static let expenseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}

// кастомный TextField
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
