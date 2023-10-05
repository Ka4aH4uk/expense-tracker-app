//
//  ExpenseDetailView.swift
//  Expense Tracker
//

import SwiftUI

struct ExpenseDetailView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @ObservedObject private var viewModel: ExpenseDetailViewModel
    @State private var showExpensesModal = false
    @State private var showExpenseChart = false
    @Environment(\.dismiss) private var dismiss
    
    init(category: ExpenseCategory) {
        _viewModel = ObservedObject(wrappedValue: ExpenseDetailViewModel(category: category))
    }
    
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        NavigationStack {
            Divider()
                .padding(.horizontal, 10)
            
            NavigationLink {
                ExpenseChartView(category: viewModel.category, showExpenseChart: $showExpenseChart)
            } label: {
                Text("График платежей")
                    .font(.headline).bold()
                    .frame(width: 320)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [.red, .pink.opacity(0.8)]), startPoint: .top, endPoint: .center))
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
                        Text("А пока список пуст, давайте просто посмотрим в окно и поймем, сколько ошибок допустил метеоролог")
                            .font(.body)
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
                    .background(LinearGradient(gradient: Gradient(colors: [.red, .pink.opacity(0.8)]), startPoint: .top, endPoint: .center))
                    .clipShape(Circle())
                    .padding()
                }
                .padding()
                .shadow(color: isDarkMode ? .white : .gray, radius: 4, x: 0, y: 0)
                .sheet(isPresented: $showExpensesModal) {
                    AddExpenseView(viewModel: viewModel, showSheet: $showExpensesModal)
                        .presentationDetents([.height(270)])
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
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
