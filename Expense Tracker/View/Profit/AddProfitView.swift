//
//  AddProfitView.swift
//  Expense Tracker
//

import SwiftUI

struct AddProfitView: View {
    @Binding var showSheet: Bool
    @State private var amountText = ""
    @State private var selectedDate = Date()
    var addProfitCategory: (Double, Date) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                TextField("Сумма", text: $amountText)
                    .floatingPlaceholder("Сумма", text: $amountText)
                    .keyboardType(.decimalPad)
                    .onReceive(amountText.publisher.collect()) { string in
                        if string.count > 8 {
                            self.amountText = String(string.prefix(8))
                        }
                    }
                DatePicker(selection: $selectedDate, displayedComponents: .date) {
                    Image(systemName: "calendar")
                }
            }

            Divider()
                .padding(.horizontal, 5)
            Button(action: {
                guard let amount = Double(amountText) else { return }
                addProfitCategory(amount, selectedDate)
                showSheet = false
            }, label: {
                HStack {
                    Spacer()
                    Text("Добавить")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .contentShape(Rectangle())
            })
            .disabled(amountText.isEmpty) // кнопка неактивна, если текстовое поле пустое
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 350, height: 50)
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing).opacity(amountText.isEmpty ? 0.5 : 1.0))
            .cornerRadius(30)
            .padding()
            Spacer()
        }
        .padding()
    }
}

struct AddProfitView_Previews: PreviewProvider {
    static var previews: some View {
        AddProfitView(showSheet: .constant(true), addProfitCategory: { amount, date in
            print("Amount: \(amount)")
            print("Selected Date: \(date)")
        })
        .previewDisplayName("Add Profit View")
        .environment(\.locale, .init(identifier: "ru_RU"))
        .environment(\.colorScheme, .light)
        .padding()
    }
}
