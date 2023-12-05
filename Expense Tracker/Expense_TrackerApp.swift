//
//  Expense_TrackerApp.swift
//  Expense Tracker
//

import SwiftUI

@main
struct Expense_TrackerApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("showOnboarding") var showOnboarding: Bool = false

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                MainTabScreen()
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            } else {
                OnboardingView(showOnboarding: $showOnboarding)
                    .ignoresSafeArea()
            }
        }
    }
}
