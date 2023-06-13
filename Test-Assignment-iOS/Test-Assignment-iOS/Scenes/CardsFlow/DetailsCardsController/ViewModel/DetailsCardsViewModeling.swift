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

protocol DetailsCardsViewModelingInput { }

protocol DetailsCardsViewModelingOutput {
    var cardModel: AnyPublisher<Card, Never> { get }
}
