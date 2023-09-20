//
//  OnboardingViewModel.swift
//  Expense Tracker
//

import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var models: [OnboardingModel] = []

    init() {
        models.append(OnboardingModel(imageName: "1",
                                      title: "Добро пожаловать в мир финансовой свободы",
                                      description: "Мы поможем вам освоить искусство финансового управления и достичь своих финансовых целей!",
                                      showDoneButton: false))
        
        models.append(OnboardingModel(imageName: "2",
                                      title: "Освойте искусство управления деньгами",
                                      description: "Станьте хозяином своих финансов и откройте новые возможности для своих мечт!",
                                      showDoneButton: false))
        
        models.append(OnboardingModel(imageName: "3",
                                      title: "Станьте мастером своих финансов",
                                      description: "Научитесь эффективно управлять своими деньгами и сделайте финансовую независимость реальностью!",
                                      showDoneButton: true))
    }
}
