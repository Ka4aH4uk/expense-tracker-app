//
//  AddCostsView.swift
//  Expense Tracker
//

import SwiftUI

struct AddCostsView: View {
    @Binding var showSheet: Bool
    @Binding var categoryText: String
    var onAddCategory: (String) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Наименование", text: $categoryText)
                .floatingPlaceholder("Наименование", text: $categoryText)
                .disableAutocorrection(true)
                .autocapitalization(.sentences)
            Divider()
                .padding(.horizontal, 15)
            Button("Добавить категорию расходов", action: {
                onAddCategory(categoryText)
                showSheet = false
            })
            .disabled(categoryText.isEmpty) // кнопка неактивна, если текстовое поле пустое
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 350, height: 50)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .leading, endPoint: .trailing).opacity(categoryText.isEmpty ? 0.5 : 1.0))
            .cornerRadius(30)
            .padding()
        }
    }
}

struct AddCostsView_Previews: PreviewProvider {
    @State static var showSheet = false
    @State static var categoryText = ""
    static var categoriesData = [ExpenseCategory(name: "Category 1"), ExpenseCategory(name: "Category 2")]
    
    static func onAddCategory(_ category: String) {
        print("Добавлена категория: \(category)")
    }
    
    static var previews: some View {
        AddCostsView(showSheet: $showSheet, categoryText: $categoryText, onAddCategory: onAddCategory)
    }
}

