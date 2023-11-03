//
//  TabBar.swift
//  Expense Tracker
//

import SwiftUI

struct MainTabScreen: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @State private var selectedTab: Tabs = .expense
   
    var body: some View {
        VStack {
            selectedTab.view()
                .transition(.identity)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            HStack {
                ForEach(Tabs.allCases, id: \.rawValue) { tab in
                    tab.label()
                        .font(.subheadline.bold())
                        .foregroundStyle(selectedTab == tab ? (isDarkMode ? .blue.opacity(0.8) : .blue) : (isDarkMode ? .white.opacity(0.6) : .gray.opacity(0.8)))
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedTab = tab
                            }
                        }
                        .scaleEffect(selectedTab == tab ? 1.0 : 0.85)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 5)
            .padding(.top, 15)
            .padding(.bottom, 7)
            .frame(height: 78, alignment: .top)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding(.horizontal)
            .background(
                HStack {
                    if selectedTab == .expense { Spacer() }
                    if selectedTab == .graph {
                        Spacer()
                        Spacer()
                    }
                    Circle()
                        .fill(.blue.opacity(0.2).gradient)
                        .frame(width: 80)
                    if selectedTab == .graph {
                        Spacer()
                        Spacer()
                    }
                    if selectedTab == .profit { Spacer() }
                }
                .padding(.horizontal, 38)
            )
            .overlay(
                HStack {
                    if selectedTab == .expense { Spacer() }
                    if selectedTab == .graph {
                        Spacer()
                        Spacer()
                    }
                    Rectangle()
                        .fill(.blue.opacity(0.6).gradient)
                        .frame(width: 25, height: 5)
                        .cornerRadius(3)
                        .frame(width: 78)
                        .frame(maxHeight: .infinity, alignment: .top)
                    if selectedTab == .graph {
                        Spacer()
                        Spacer()
                    }
                    if selectedTab == .profit { Spacer() }
                }
                .padding(.horizontal, 38)
            )
        }
    }

    enum Tabs: String, CaseIterable {
        case profit
        case graph
        case expense
        
        @ViewBuilder func view() -> some View {
            switch self {
            case .profit:
                ProfitView()
            case .graph:
                ChartView()
            case .expense:
                ExpenseView()
            }
        }

        @ViewBuilder func image() -> some View {
            switch self {
            case .profit:
                Image(systemName: "rublesign")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .graph:
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .expense:
                Image(systemName: "cart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }

        @ViewBuilder func label() -> some View {
            switch self {
            case .profit:
                VStack{
                    image()
                    Text("Доходы")
                }
            case .graph:
                VStack{
                    image()
                    Text("График")
                }
            case .expense:
                VStack{
                    image()
                    Text("Расходы")
                }
            }
        }
    }
}

struct MainTabScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainTabScreen()
    }
}

// MARK: -- Default TabBar
//struct TabBar: View {
//    @StateObject var router: TabBarRouter
//    @AppStorage("isDarkMode") var isDarkMode: Bool = false
//    @State private var selectedTab: TabSelection = .expense
//
//    var body: some View {
//        TabView(selection: $router.tabSelection) {
//            ProfitView()
//                .tabItem {
//                    Label("Доходы", systemImage: "rublesign")
//                }
//                .tag(TabSelection.profit)
//
//            ChartView()
//                .tabItem {
//                    Label("График", systemImage: "chart.line.uptrend.xyaxis")
//                }
//                .tag(TabSelection.graph)
//
//            ExpenseView()
//                .tabItem {
//                    Label("Расходы", systemImage: "cart")
//                }
//                .tag(TabSelection.expense)
//        }
//        .accentColor(isDarkMode ? .white.opacity(0.9) : .blue.opacity(0.9))
//        .environmentObject(router)
//    }
//}
//struct TabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBar(router: TabBarRouter())
//            .environmentObject(TabBarRouter())
//    }
//}
