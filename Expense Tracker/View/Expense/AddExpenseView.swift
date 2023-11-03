//
//  AddExpenseView.swift
//  Expense Tracker
//

import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var viewModel: ExpenseDetailViewModel
    @Binding var showSheet: Bool
    @State private var nameText = ""
    @State private var amountText = ""
    @State private var selectedDate = Date()
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Наименование", text: $nameText)
                .floatingPlaceholder(NSLocalizedString("Наименование", comment: ""), text: $nameText)
                .disableAutocorrection(true)
                .autocapitalization(.sentences)
            Divider()
                .padding(.horizontal, 15)
            
            TextField("Сумма", text: $amountText)
                .floatingPlaceholder(NSLocalizedString("Сумма", comment: ""), text: $amountText)
                .keyboardType(.decimalPad)
            Divider()
                .padding(.horizontal, 15)
            
            DatePicker(selection: $selectedDate, displayedComponents: .date) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.title2)
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
                
                if let amount = Double(amountText.decimalFormatted) {
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
            .frame(height: 50)
            .background(LinearGradient(gradient: Gradient(colors: [.red, .pink.opacity(0.8)]), startPoint: .top, endPoint: .center))
            .cornerRadius(30)
            .padding(.bottom).padding(.top).padding(.horizontal)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Ну-ка, давай по-честному!"),
                      message: Text("До чего же сложно заполнить поля с наименованием и суммой, а?"),
                      dismissButton: .default(Text("Я справлюсь, обещаю!")))
            }
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ExpenseDetailViewModel(category: ExpenseCategory(name: "Категория"))
        return AddExpenseView(viewModel: viewModel, showSheet: .constant(true))
    }
}
