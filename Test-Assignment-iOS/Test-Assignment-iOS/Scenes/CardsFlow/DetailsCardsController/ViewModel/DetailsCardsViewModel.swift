//
//  DetailsCardsViewModel.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Combine
import Foundation

final class DetailsCardsViewModel: DetailsCardsViewModeling {
 
    struct Input: DetailsCardsViewModelingInput { }
    
    struct Output: DetailsCardsViewModelingOutput {
        var cardModel: AnyPublisher<Card, Never>
    }
    
    lazy var input: Input = Input()
    
    lazy var output: Output = Output(cardModel: cardModel)
    
    // Input
    private let viewDidLoad = PassthroughSubject<Void, Never>()
    
    // Output
    private var cardModel: AnyPublisher<Card, Never> {
        $card.eraseToAnyPublisher()
    }
    private let onError = PassthroughSubject<Error, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published private var card: Card
    
    init(card: Card) {
        self.card = card
    }
}
