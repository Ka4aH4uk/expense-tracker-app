//
//  ExpenseView.swift
//  Expense Tracker
//

import SwiftUI

struct ExpenseView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isChangeTheme") private var isChangeTheme: Bool = false
    @StateObject private var viewModel = ExpenseViewModel()
    @State private var isEditing = false
    @State private var showCostsModal = false
    @State private var categoryText = ""
    
    var body: some View {
        NavigationStack {
            Spacer()
            
            if viewModel.expenseCategories.isEmpty {
                Image(systemName: "cart.badge.plus")
                    .font(.largeTitle)
                Text("Список еще не готов, но мы можем предположить, что жадность бесконечна, как и список количества покупок")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List {
                    ForEach(viewModel.expenseCategories) { category in
                        NavigationLink {
                            ExpenseDetailView(category: category)
                        } label: {
                            HStack {
                                if let iconName = category.iconName {
                                    Image(iconName)
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                }
                                VStack(alignment: .leading) {
                                    Text(category.name)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 0.5)
                                    Text(NSLocalizedString("Кол-во платежей: ", comment: "") + "\(category.numberOfExpenses)")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                        }
                        .padding(.top, 15).padding(.bottom, 15).padding(.horizontal)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.red, .pink.opacity(0.8)]), startPoint: .top, endPoint: .center)
                                .cornerRadius(30)
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: isEditing ? delete : nil)
                    .onMove(perform: isEditing ? move : nil)
                }
                .padding(.horizontal, -5)
                .listStyle(.plain)
            }
            Spacer()
            
            Button(action: {
                showCostsModal = true
            }) {
                HStack {
                    Spacer()
                    Text("Добавить категорию расходов")
                        .font(.headline).bold()
                    .foregroundColor(.white)
                    Spacer()
                }
            }
            .padding()
            .frame(height: 50)
            .background(LinearGradient(gradient: Gradient(colors: [.red, .pink.opacity(0.8)]), startPoint: .top, endPoint: .center))
            .cornerRadius(30)
            .shadow(color: isDarkMode ? .white : .gray, radius: 4, x: 0, y: 0)
            .padding(.bottom).padding(.horizontal)
            .sheet(isPresented: $showCostsModal) {
                AddCostsView(showSheet: $showCostsModal, categoryText: $categoryText, onAddCategory: { name, iconName in
                    viewModel.addCategory(name: name, iconName: iconName)
                })
                .presentationDetents([.medium])
                Spacer()
            }
            .onDisappear {
                viewModel.saveCategories()
                isEditing = false
            }
            .navigationBarTitle(Text("Расходы"), displayMode: .large)
            .navigationBarItems(
                
                leading: VStack {
                    if !viewModel.expenseCategories.isEmpty {
                        Button {
                            isEditing.toggle()
                        } label: {
                            if isEditing {
                                LottieView(name: "done", animationSpeed: 0.5)
                                    .scaleEffect(0.13)
                                    .opacity(0.9)
                                    .frame(width: 20, height: 20)
                            } else {
                                LottieView(name: "edit", animationSpeed: 1)
                                    .scaleEffect(0.8)
                                    .opacity(0.9)
                                    .frame(width: 20, height: 20)
                            }
                        }
                    }
                }.padding(.leading, 5),
                
                trailing: Button {
                    isDarkMode.toggle()
                    isChangeTheme.toggle()
                } label: {
                    if isChangeTheme {
                        LottieView(name: "sun", animationSpeed: 0.6)
                            .scaleEffect(1.3)
                            .opacity(0.8)
                            .frame(width: 20, height: 20)
                        
                    } else {
                        LottieView(name: "moon", animationSpeed: 0.6)
                            .scaleEffect(1.6)
                            .opacity(0.8)
                            .frame(width: 20, height: 20)
                    }
                        
                }.padding(.trailing, 5)
            )
        }
    }
    
    func delete(at offsets: IndexSet) {
        viewModel.deleteCategory(at: offsets)
        isEditing = false
    }
    
    func move(from source: IndexSet, to destination: Int) {
        viewModel.expenseCategories.move(fromOffsets: source, toOffset: destination)
    }
}

struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView()
//            .environmentObject(TabBarRouter())
    }
}
