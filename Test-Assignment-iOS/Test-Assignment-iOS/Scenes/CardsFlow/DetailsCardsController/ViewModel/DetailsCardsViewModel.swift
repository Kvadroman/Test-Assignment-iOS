//
//  DetailsCardsViewModel.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Combine
import Foundation

final class DetailsCardsViewModel: DetailsCardsViewModeling {
 
    struct Input: DetailsCardsViewModelingInput {
        var viewDidLoad: PassthroughSubject<Void, Never>
    }
    
    struct Output: DetailsCardsViewModelingOutput {
        var cardModel: AnyPublisher<Card, Never>
        var onError: PassthroughSubject<Error, Never>
        var onClose: PassthroughSubject<Void, Never>
    }
    
    lazy var input: Input = Input(viewDidLoad: viewDidLoad)
    
    lazy var output: Output = Output(cardModel: cardModel,
                                     onError: onError,
                                     onClose: onClose)
    
    // Input
    private let viewDidLoad = PassthroughSubject<Void, Never>()
    
    // Output
    private var cardModel: AnyPublisher<Card, Never> {
        $card.eraseToAnyPublisher()
    }
    private let onError = PassthroughSubject<Error, Never>()
    private let onClose = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published private var card: Card
    
    init(card: Card) {
        self.card = card
        bind()
    }
    
    private func bind() {

    }
}
