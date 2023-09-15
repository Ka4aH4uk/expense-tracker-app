//
//  Expense_TrackerApp.swift
//  Expense Tracker
//

import SwiftUI

@main
struct Expense_TrackerApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("showOnboarding") var showOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                TabBar(router: TabBarRouter())
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .environment(\.locale, .init(identifier: "ru_RU"))
            } else {
                OnboardingView(showOnboarding: $showOnboarding)
                    .ignoresSafeArea()
            }
        }
    }
}
