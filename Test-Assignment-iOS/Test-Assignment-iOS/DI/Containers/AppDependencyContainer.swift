//
//  AppDependencyContainer.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Foundation
import Swinject

class AppDependencyContainer {
    private lazy var appDIContainer: Container = {
        Container { container in
            // MARK: - Router
            container.register(RouterType.self) { _ in
                Router()
            }.inObjectScope(.weak)
            
            // MARK: - Card Mask
            container.register(CardMaskProtocol.self) { _ in
                CardMask()
            }.inObjectScope(.container)
            
            container.register(DetailsCardMaskProtocol.self) { _ in
                CardMask()
            }.inObjectScope(.container)
            
            // MARK: - CoreData Repository
            container.register(CDCardRepositoryProtocol.self) { _ in
                CDCardRepository()
            }.inObjectScope(.container)
            
            // MARK: - App Coordinator
            container.register(AppCoordinator.self) { resolver in
                let router = resolver.resolve(RouterType.self)!
                let cardCoordinatorDIC = CardsDependencyContainer(parentContainer: container)
                let cardCoordinator: (RouterType) -> CardCoordinator = { router in
                    return cardCoordinatorDIC.makeCardCoordinator(parentRouter: router)
                }
                return AppCoordinator(router: router, cardsCoordinator: cardCoordinator)
            }.inObjectScope(.container)
        }
    }()
    
    func makeCoordinator() -> AppCoordinator {
        appDIContainer.resolve(AppCoordinator.self)!
    }
}
