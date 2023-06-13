//
//  CardsViewModeling.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import RxCocoa
import RxSwift
import UIKit

protocol CardsViewModeling: ViewModel where Input: CardsViewModelingInput, Output: CardsViewModelingOutput {
}

protocol CardsViewModelingInput {
    var didAddCard: AnyObserver<Void> { get }
    var didSelectItem: AnyObserver<Card> { get }
}

protocol CardsViewModelingOutput {
    var cardsModel: Observable<[Card]> { get }
    var onError: Observable<Error> { get }
    var onOpenDetailsCard: Observable<Card> { get }
}
