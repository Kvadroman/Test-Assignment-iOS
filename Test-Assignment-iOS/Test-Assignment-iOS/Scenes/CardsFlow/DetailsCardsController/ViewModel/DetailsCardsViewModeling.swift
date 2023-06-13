//
//  DetailsCardsViewModeling.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Combine
import UIKit

protocol DetailsCardsViewModeling: ViewModel where Input: DetailsCardsViewModelingInput, Output: DetailsCardsViewModelingOutput {
}

protocol DetailsCardsViewModelingInput {
    var viewDidLoad: PassthroughSubject<Void, Never> { get }
}

protocol DetailsCardsViewModelingOutput {
    var cardModel: AnyPublisher<Card, Never> { get }
    var onError: PassthroughSubject<Error, Never> { get }
    var onClose: PassthroughSubject<Void, Never> { get }
}
