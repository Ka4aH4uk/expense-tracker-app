//
//  ProfitView.swift
//  Expense Tracker
//

import SwiftUI

struct ProfitView: View {
    @StateObject private var viewModel = ProfitViewModel()
    @State private var showProfitModal = false
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Доходы")
                    .font(.title).bold()
            }
            
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
            .backgroundStyle(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.indigo.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
            .padding(.leading)
            .padding(.trailing)
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
                    ForEach(viewModel.profitCategories.sorted(by: { $0.date > $1.date })) { profit in
                        HStack {
                            Text(String(format: "%.2f", profit.amount) + "\u{20BD}")
                            Spacer()
                            Text(DateFormatter.expenseDateFormatter.string(from: profit.date)).opacity(0.5)
                        }
                    }
                }
                .listStyle(.plain)
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
        }
    }
}

struct ProfitView_Previews: PreviewProvider {
    static var previews: some View {
        ProfitView()
            .environmentObject(TabBarRouter())
    }
}
