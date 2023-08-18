//
//  ExpenseView.swift
//  Expense Tracker
//

import SwiftUI

struct ExpenseView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isChangeTheme") private var isChangeTheme: Bool = false
    @StateObject private var viewModel = ExpenseViewModel()
    @State private var showCostsModal = false
    @State private var categoryText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Text("Расходы")
                        .font(.largeTitle).bold()
                        .padding()
                    Spacer()
                        .overlay {
                            Button {
                                isDarkMode.toggle()
                                isChangeTheme.toggle()
                            } label: {
                                if isChangeTheme {
                                    LottieView(name: "sun")
                                        .scaleEffect(1.5)
                                } else {
                                    LottieView(name: "moon")
                                        .scaleEffect(2)
                                }
                            }
                            .padding(.leading, 40)
                        }
                }
                Spacer()
                
                if viewModel.expenseCategories.isEmpty {
                    Image(systemName: "cart.badge.plus")
                        .font(.largeTitle)
                    Text("Список еще не готов, но мы можем\n предположить, что жадность бесконечна,\n как и список количества покупок")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List(viewModel.expenseCategories) { category in
                        NavigationLink(
                            destination: ExpenseDetailView(category: category),
                            label: {
                                HStack {
                                    Image(systemName: "diamond")
                                        .font(.title2)
                                    VStack(alignment: .leading) {
                                        Text(category.name)
                                            .font(.headline)
                                            .foregroundColor(isDarkMode ? .white : .black)
                                        Text("Кол-во платежей: \(category.numberOfExpenses)")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                }
                            })
                        .foregroundColor(.blue)
                        .frame(height: 45)
                    }
                    .listStyle(.plain)
                }
                Spacer()
                
                Button(action: {
                    showCostsModal = true
                }) {
                    Text("Добавить категорию расходов")
                        .font(.headline).bold()
                        .foregroundColor(.white)
                }
                .padding()
                .frame(width: 350)
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(30)
                .padding()
                .sheet(isPresented: $showCostsModal) {
                    AddCostsView(showSheet: $showCostsModal, categoryText: $categoryText, onAddCategory: viewModel.addCategory)
                        .presentationDetents([.height(160)])
                    Spacer()
                }
            }
            .onDisappear {
                viewModel.saveCategories()
            }
        }
    }
}

struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView()
            .environmentObject(TabBarRouter())
    }
}
