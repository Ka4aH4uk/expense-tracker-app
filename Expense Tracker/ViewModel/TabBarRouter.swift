//
//  TabBarRouter.swift
//  Expense Tracker
//

import Foundation

enum TabSelection: Int {
    case profit, graph, espense
}

final class TabBarRouter: ObservableObject {
    @Published var tabSelection: TabSelection = .espense
}
