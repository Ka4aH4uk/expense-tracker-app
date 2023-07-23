//
//  TabBar.swift
//  Expense Tracker
//

import SwiftUI

struct TabBar: View {
    @StateObject var router: TabBarRouter

    var body: some View {
        TabView(selection: $router.tabSelection) {
            ProfitView()
                .tabItem {
                    Label("Доходы", systemImage: "rublesign")
                }
                .tag(TabSelection.profit)

            ChartView()
                .tabItem {
                    Label("График", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(TabSelection.graph)

            ExpenseView()
                .tabItem {
                    Label("Расходы", systemImage: "cart")
                }
                .tag(TabSelection.espense)
        }
        .environmentObject(router)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(router: TabBarRouter())
            .environmentObject(TabBarRouter())
    }
}
