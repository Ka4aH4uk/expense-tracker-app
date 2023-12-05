//
//  OnboardingViewModel.swift
//  Expense Tracker
//

import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var models: [OnboardingModel] = []

    init() {
        models.append(OnboardingModel(imageName: "1",
                                      title: NSLocalizedString("Добро пожаловать в мир финансовой свободы", comment: ""),
                                      description: NSLocalizedString("Мы поможем вам освоить искусство финансового управления и достичь своих финансовых целей!", comment: ""),
                                      showDoneButton: false))
        
        models.append(OnboardingModel(imageName: "2",
                                      title: NSLocalizedString("Освойте искусство управления деньгами", comment: ""),
                                      description: NSLocalizedString("Станьте хозяином своих финансов и откройте новые возможности для своих мечт!", comment: ""),
                                      showDoneButton: false))
        
        models.append(OnboardingModel(imageName: "3",
                                      title: NSLocalizedString("Станьте мастером своих финансов", comment: ""),
                                      description: NSLocalizedString("Научитесь эффективно управлять своими деньгами и сделайте финансовую независимость реальностью!", comment: ""),
                                      showDoneButton: true))
    }
}
