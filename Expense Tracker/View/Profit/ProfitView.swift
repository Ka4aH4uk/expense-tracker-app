//
//  ProfitView.swift
//  Expense Tracker
//

import SwiftUI

struct ProfitView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @StateObject private var viewModel = ProfitViewModel()
    @State private var showProfitModal = false

    var body: some View {
        NavigationStack {
            GroupBox {
                HStack {
                    Text("Текущий баланс:")
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Text((String(format: "%.2f", viewModel.balance)) + "\u{20BD}")
                        .font(.title3).bold()
                        .multilineTextAlignment(.trailing)
                }
                .foregroundStyle(Color.white.gradient)
            }
            .backgroundStyle(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.indigo.opacity(0.8)]), startPoint: .top, endPoint: .center))
            .padding(.leading).padding(.trailing).padding(.top)
            Spacer()

            if viewModel.profitCategories.isEmpty {
                Image(systemName: "rublesign.circle")
                    .font(.largeTitle)
                Text("Как говорится, доходы у меня настолько маленькие, что мои налоговые декларации вмещаются в твиттер")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List {
                    ForEach(Array(viewModel.profitCategories.keys).sorted(by: >), id: \.self) { month in
                        DisclosureGroup(
                            isExpanded: Binding<Bool>(
                                get: { viewModel.expandedSections.contains(month) },
                                set: { isExpanding in
                                    if isExpanding {
                                        viewModel.expandedSections.insert(month)
                                    } else {
                                        viewModel.expandedSections.remove(month)
                                    }
                                }
                            ), content: {
                                ForEach(viewModel.profitCategories[month]?.sorted(by: { $0.date > $1.date }) ?? [], id: \.id) { profit in
                                    HStack {
                                        Text(String(format: "%.2f", profit.amount) + "\u{20BD}")
                                        Spacer()
                                        Text(DateFormatter.expenseDateFormatter.string(from: profit.date)).opacity(isDarkMode ? 0.7 : 0.4)
                                    }
                                }
                            },
                            label: {
                                Text(month)
                                    .foregroundStyle(.blue.gradient)
                                    .font(.title3)
                            }
                        )
                        .accentColor(.indigo)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .padding()
            }

            Spacer()
            Button(action: {
                showProfitModal = true
            }) {
                HStack {
                    Spacer()
                    Text("Добавить доход")
                        .font(.headline).bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .padding()
            .frame(width: 350)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.indigo.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(30)
            .shadow(color: isDarkMode ? .white : .gray, radius: 4, x: 0, y: 0)
            .padding(.bottom)
            .sheet(isPresented: $showProfitModal) {
                AddProfitView(showSheet: $showProfitModal) { amount, date in
                    viewModel.addProfit(amount: amount, date: date)
                }
                .presentationDetents([.height(160)])
            }
            .navigationBarTitle(Text("Доходы"), displayMode: .large)
        }
    }
}

struct ProfitView_Previews: PreviewProvider {
    static var previews: some View {
        ProfitView()
            .environmentObject(TabBarRouter())
    }
}
