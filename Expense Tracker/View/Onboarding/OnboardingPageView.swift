//
//  OnboardingPageView.swift
//  Expense Tracker
//

import SwiftUI

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    
    let showDoneButton: Bool
    
    var nextAction: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.9))
                
                Text(description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .foregroundColor(.black.opacity(0.7))
                
                if showDoneButton {
                    Button(action: {
                        nextAction()
                    }) {
                        HStack {
                            Spacer()
                            Text("Приступим?")
                                .font(.headline).bold()
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .padding()
                    .frame(width: 160)
                    .background(.blue.gradient)
                    .cornerRadius(30)
                    .shadow(color: .gray, radius: 4, x: 0, y: 0)
                    .padding(.top)
                } else {
                    Button(action: {
                        nextAction()
                    }) {
                        HStack {
                            Spacer()
                            Text("Далее")
                                .font(.headline).bold()
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .padding()
                    .frame(width: 160)
                    .background(.blue.gradient)
                    .cornerRadius(30)
                    .shadow(color: .gray, radius: 4, x: 0, y: 0)
                    .padding(.top)
                }
            }
            .padding()
        }
    }
}

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            OnboardingPageView(imageName: "dollarsign",
                               title: "Добро пожаловать",
                               description: "Добро пожаловать в финансовый рай! Мы добавим яркие краски в ваши финансы и поможем им расцвести!",
                               showDoneButton: false,
                               nextAction: goNext)
            .tag(0)
            
            OnboardingPageView(imageName: "bag",
                               title: "Освойте искусство управления деньгами",
                               description: "Станьте хозяином своих финансов и откройте новые возможности для своих мечт!",
                               showDoneButton: false,
                               nextAction: goNext)
            .tag(1)
            
            OnboardingPageView(imageName: "figure.fall",
                               title: "Будьте свободны в финансах и жизни",
                               description: "Связывайте доходы с удовольствиями, чтобы жить полной жизнью без финансовых ограничений!",
                               showDoneButton: true,
                               nextAction: {
                showOnboarding = true
            })
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
    
    func goNext() {
        withAnimation {
            selection += 1
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView(imageName: "dollarsign", title: "Welcome", description: "Добро пожаловать!", showDoneButton: true, nextAction: { })
    }
}
