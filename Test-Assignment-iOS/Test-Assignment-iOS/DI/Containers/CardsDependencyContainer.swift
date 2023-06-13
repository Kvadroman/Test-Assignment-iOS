//
//  CardsDependencyContainer.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Swinject
import UIKit

// MARK: - Cards Flow
class CardsDependencyContainer {
    private let container: Container
    
    init(parentContainer: Container) {
        container = Container(parent: parentContainer) { container in
            
            // MARK: - ViewModels
            container.register(CardsViewModel.self) { resolver in
                CardsViewModel(cdRepo: resolver.resolve(CDCardRepositoryProtocol.self)!)
            }
            
            container.register(DetailsCardsViewModel.self) { (resolver, card: Card) in
                DetailsCardsViewModel(card: card)
            }
            
            // MARK: - View Controllers
            container.register(CardsViewController<CardsViewModel>.self) { resolver in
                let viewModel = resolver.resolve(CardsViewModel.self)!
                let viewController = CardsViewController(viewModel: viewModel)
                viewController.cardMask = resolver.resolve(CardMaskProtocol.self)!
                return viewController
            }.inObjectScope(.container)
            
            container.register(DetailsCardsViewController<DetailsCardsViewModel>.self) { (resolver, card: Card) -> DetailsCardsViewController<DetailsCardsViewModel> in
                let viewModel = resolver.resolve(DetailsCardsViewModel.self, argument: card)!
                let viewController = DetailsCardsViewController(viewModel: viewModel)
                viewController.cardMask = resolver.resolve(DetailsCardMaskProtocol.self)!
                return viewController
            }.inObjectScope(.transient)
            
            // Card Coordinator
            container.register(CardCoordinator.self) { (resolver, router: RouterType?) in
                let cardsFactory: () -> CardsViewController<CardsViewModel> = {
                    resolver.resolve(CardsViewController<CardsViewModel>.self)!
                }
                let detailsCardsFactory: (Card) -> DetailsCardsViewController<DetailsCardsViewModel> = { card in
                    resolver.resolve(DetailsCardsViewController<DetailsCardsViewModel>.self, argument: card)!
                }
                return CardCoordinator(router: router ?? Router(),
                                       cardsFactory: cardsFactory,
                                       detailsCardsFactory: detailsCardsFactory)
            }
        }
    }
    
    func makeCardCoordinator(parentRouter: RouterType? = Router()) -> CardCoordinator {
        container.resolve(CardCoordinator.self, argument: parentRouter)!
    }
}

