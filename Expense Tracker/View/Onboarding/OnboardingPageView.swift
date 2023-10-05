//
//  OnboardingPageView.swift
//  Expense Tracker
//

import SwiftUI

struct OnboardingPageView: View {
    let model: OnboardingModel
    let nextAction: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(model.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
                    .foregroundColor(.blue)
                
                Text(model.title)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.9))
                
                Text(model.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black.opacity(0.8))
                
                Button(action: {
                    nextAction()
                }) {
                    HStack {
                        Spacer()
                        Text(model.showDoneButton ? "Приступим?" : "Далее")
                            .font(.headline).bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .padding()
                .frame(width: 200)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.indigo.opacity(0.8)]), startPoint: .top, endPoint: .center))
                .cornerRadius(30)
                .shadow(color: .gray, radius: 4, x: 0, y: 0)
                .padding(.top)
            }
            .padding()
        }
    }
}

struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        let previewModel = OnboardingModel(imageName: "1",
                                           title: "Добро пожаловать",
                                           description: "Привет! Это превью экрана онбординга. Привет! Это превью экрана онбординга. Привет! Это превью экрана онбординга.",
                                           showDoneButton: true)
        
        return OnboardingPageView(model: previewModel) {}
    }
}
