//
//  OnboardingView.swift
//  Expense Tracker
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @ObservedObject var viewModel = OnboardingViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.currentPage) {
            ForEach(viewModel.models.indices, id: \.self) { index in
                OnboardingPageView(model: viewModel.models[index]) {
                    if index < viewModel.models.count - 1 {
                        withAnimation {
                            viewModel.currentPage += 1
                        }
                    } else {
                        showOnboarding = true
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showOnboarding: .constant(true))
            .ignoresSafeArea()
    }
}
