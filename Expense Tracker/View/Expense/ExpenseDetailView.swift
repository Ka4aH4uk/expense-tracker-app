//
//  ExpenseDetailView.swift
//  Expense Tracker
//

import SwiftUI

struct ExpenseDetailView: View {
    @ObservedObject private var viewModel: ExpenseDetailViewModel
    @State private var showExpensesModal = false
    @State private var showExpenseChart = false
    @Environment(\.dismiss) private var dismiss
    
    init(category: ExpenseCategory) {
        _viewModel = ObservedObject(wrappedValue: ExpenseDetailViewModel(category: category))
    }
    
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        VStack {
            Divider()
                .padding(.horizontal, 10)
            
            NavigationLink(
                destination: ExpenseChartView(category: viewModel.category, showExpenseChart: $showExpenseChart)
            ) {
                Text("График платежей")
                    .font(.headline).bold()
                    .frame(width: 320)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(30)
            }
            .padding()
            Divider()
                .padding(.horizontal, 10)
            
            ZStack {
                if viewModel.expenses.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "list.clipboard")
                            .font(.largeTitle)
                        Text("А пока список пуст, давайте просто\n посмотрим в окно и поймем, сколько ошибок допустил метеоролог")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                            Text("На что")
                                .font(.headline)
                            Text("Когда")
                                .font(.headline)
                            Text("Сколько")
                                .font(.headline)
                            ForEach(viewModel.expenses.sorted(by: { $0.date > $1.date }), id: \.id) { expense in
                                Text("\(expense.name)")
                                Text("\(expense.date, formatter: DateFormatter.expenseDateFormatter)")
                                Text("\(expense.amount, specifier: "%.2f") \u{20BD}")
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
                
                VStack {
                    Spacer()
                    Button(action: {
                        showExpensesModal = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .frame(width: 60, height: 60)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(Circle())
                    .padding()
                }
                .padding()
                .sheet(isPresented: $showExpensesModal) {
                    AddExpenseView(viewModel: viewModel, showSheet: $showExpensesModal)
                        .presentationDetents([.height(270)])
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                    }
                }
            }
        }
    }
}

struct ExpenseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let category = ExpenseCategory(name: "Категория", expenses: [
            Expense(name: "1", amount: 100, date: Date()),
            Expense(name: "2", amount: 50, date: Date().addingTimeInterval(-86400))
        ])
        ExpenseDetailView(category: category)
    }
}
