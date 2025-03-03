//
//  CardCoordinator.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import RxSwift
import RxCocoa
import UIKit

final class CardCoordinator: Coordinator<DeepLink> {
    private let cardsFactory: () -> CardsViewController<CardsViewModel>
    private let detailsCardsFactory: (Card) -> DetailsCardsViewController<DetailsCardsViewModel>
    
    private var disposeBag = DisposeBag()
    
    private lazy var cardsVC: UIViewController = {
        let viewController = cardsFactory()
        viewController.viewModel.output.onOpenDetailsCard
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] card in
                self?.goToDetailsCards(with: card)
            })
            .disposed(by: disposeBag)
        return viewController
    }()
    
    init(router: RouterType,
         cardsFactory: @escaping () -> CardsViewController<CardsViewModel>,
         detailsCardsFactory: @escaping (Card) -> DetailsCardsViewController<DetailsCardsViewModel>) {
        self.cardsFactory = cardsFactory
        self.detailsCardsFactory = detailsCardsFactory
        super.init(router: router)
    }
    
    override func start() {
        router.setRootModule(self, animated: true)
    }
    
    override func toPresentable() -> UIViewController { cardsVC }
}

extension CardCoordinator {
    func goToDetailsCards(with card: Card) {
        let viewController = detailsCardsFactory(card)
        router.push(viewController, animated: true)
    }
    
    func goToCards() {
        router.popModule(animated: true)
    }
}
