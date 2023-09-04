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
            HStack {
                Text("Текущий баланс:")
                    .font(.callout)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
                Text((String(format: "%.2f", viewModel.balance)) + "\u{20BD}")
                    .font(.title).bold()
                    .multilineTextAlignment(.trailing)
                    .padding(.trailing, 10)
            }
            HStack(alignment: .center) {
                Text("Доходы")
                    .font(.largeTitle).bold()
            }
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
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(30)
            .shadow(color: isDarkMode ? .white : .gray, radius: 4, x: 0, y: 0)
            .padding()
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
