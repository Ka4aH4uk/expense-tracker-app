//
//  AddExpenseView.swift
//  Expense Tracker
//

import SwiftUI

struct AddExpenseView: View {
    let category: ExpenseCategory
    @Binding var showSheet: Bool
    @State private var nameText = ""
    @State private var amountText = ""
    @State private var selectedDate = Date()
    @State private var showAlert = false
    
    @ObservedObject private var viewModel: ExpenseDetailViewModel
    
    init(category: ExpenseCategory, showSheet: Binding<Bool>, expenses: Binding<[Expense]>, allExpenses: Binding<[Expense]>) {
        self.category = category
        _showSheet = showSheet
        _viewModel = ObservedObject(wrappedValue: ExpenseDetailViewModel(category: category))
    }

    var body: some View {
        VStack {
            Spacer()
            
            TextField("Наименование", text: $nameText)
                .floatingPlaceholder("Наименование", text: $nameText)
                .disableAutocorrection(true)
                .autocapitalization(.sentences)
            Divider()
                .padding(.horizontal, 15)
            
            TextField("Сумма", text: $amountText)
                .floatingPlaceholder("Сумма", text: $amountText)
                .keyboardType(.decimalPad)
            Divider()
                .padding(.horizontal, 15)
            
            DatePicker(selection: $selectedDate, displayedComponents: .date) {
                HStack {
                    Image(systemName: "calendar")
                    Text("Дата платежа")
                }
            }
            .padding(.horizontal, 20)
            Divider()
                .padding(.horizontal, 15)
            
            Button(action: {
                guard !nameText.isEmpty && !amountText.isEmpty else {
                    showAlert = true
                    return
                }
                
                if let amount = Double(amountText) {
                    viewModel.addExpense(name: nameText, amount: amount, date: selectedDate)
                    showSheet = false
                }
            }) {
                HStack {
                    Spacer()
                    Text("Добавить расход")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 350, height: 50)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]),
                                       startPoint: .leading, endPoint: .trailing))
            .cornerRadius(30)
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Ну-ка, давай по-честному!"),
                      message: Text("До чего же сложно заполнить поля с наименованием и суммой, а?"),
                      dismissButton: .default(Text("Я справлюсь, обещаю!")))
            }
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    @State private static var showSheet = true
    @State private static var expenses: [Expense] = []
    @State private static var allExpenses: [Expense] = []

    static var previews: some View {
        AddExpenseView(category: ExpenseCategory(name: "Категория"),
                       showSheet: $showSheet,
                       expenses: $expenses,
                       allExpenses: $allExpenses)
    }
}