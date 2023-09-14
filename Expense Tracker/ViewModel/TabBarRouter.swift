//
//  TabBarRouter.swift
//  Expense Tracker
//

import Foundation

enum TabSelection: String {
    case profit, graph, expense
}

final class TabBarRouter: ObservableObject {
    @Published var tabSelection: TabSelection = .expense
}
