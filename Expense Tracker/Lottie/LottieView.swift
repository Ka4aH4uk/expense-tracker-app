//
//  SunMoonLottieView.swift
//  Expense Tracker
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    @Binding var isChangeTheme: Bool
    
    init(name: String, loopMode: LottieLoopMode = .playOnce, animationSpeed: CGFloat = 1, isChangeTheme: Binding<Bool> = .constant(false)) {
        self.name = name
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self._isChangeTheme = isChangeTheme
    }
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.play()
        return animationView
    }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) {
       
    }
}
