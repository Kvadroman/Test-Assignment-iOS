//
//  DetailsCardsViewModeling.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import RxSwift
import RxCocoa
import UIKit

protocol DetailsCardsViewModeling: ViewModel where Input: DetailsCardsViewModelingInput, Output: DetailsCardsViewModelingOutput {
}

protocol DetailsCardsViewModelingInput { }

protocol DetailsCardsViewModelingOutput {
    var cardModel: Driver<Card> { get }
}
