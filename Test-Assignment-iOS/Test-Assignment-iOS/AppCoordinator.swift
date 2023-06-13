//
//  AppCoordinator.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

enum DeepLink {
    case cards
}

import UIKit

class AppCoordinator: Coordinator<DeepLink> {
    
    private let cardsCoordinator: (RouterType) -> CardCoordinator
    
    init(router: RouterType,
         cardsCoordinator: @escaping (RouterType) -> CardCoordinator) {
        self.cardsCoordinator = cardsCoordinator
        super.init(router: router)
    }
    
    override func start(with link: DeepLink?) {
        guard let link else {
            return
        }
        switch link {
        case .cards:
            goToCardsFlow()
        }
    }
}

// MARK: - Navigation
extension AppCoordinator {
    func goToCardsFlow() {
        childCoordinators.removeAll()
        let coordinator = cardsCoordinator(router)
        addChild(coordinator)
        coordinator.start()
    }
}
