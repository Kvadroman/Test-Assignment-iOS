//
//  CardsViewModeling.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Combine
import UIKit

protocol CardsViewModeling: ViewModel where Input: CardsViewModelingInput, Output: CardsViewModelingOutput {
}

protocol CardsViewModelingInput {
    var didAddCard: PassthroughSubject<Void, Never> { get }
    var didSelectItem: PassthroughSubject<Card, Never> { get }
}

protocol CardsViewModelingOutput {
    var cardsModel: AnyPublisher<[Card], Never> { get }
    var onError: PassthroughSubject<Error, Never> { get }
    var onOpenDetailsCard: PassthroughSubject<Card, Never> { get }
}
