//
//  DetailsCardsViewModel.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import RxSwift
import RxCocoa

final class DetailsCardsViewModel: DetailsCardsViewModeling {
    
    struct Input: DetailsCardsViewModelingInput { }
    
    struct Output: DetailsCardsViewModelingOutput {
        var cardModel: Driver<Card>
    }
    
    lazy var input: Input = Input()
    
    lazy var output: Output = Output(cardModel: cardModel)
    
    // Output
    private var cardModel: Driver<Card> {
        card.asDriver(onErrorJustReturn: Card.defaultCard)
    }
    
    private var disposeBag = DisposeBag()
    
    private var card = BehaviorSubject<Card>(value: Card.defaultCard)
    
    init(card: Card) {
        self.card.onNext(card)
    }
}
