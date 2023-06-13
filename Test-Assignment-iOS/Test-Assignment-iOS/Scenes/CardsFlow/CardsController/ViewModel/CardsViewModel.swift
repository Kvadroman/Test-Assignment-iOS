//
//  CardsViewModel.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Combine
import Foundation

final class CardsViewModel: CardsViewModeling {
 
    struct Input: CardsViewModelingInput {
        var didAddCard: PassthroughSubject<Void, Never>
        var didSelectItem: PassthroughSubject<Card, Never>
    }
    
    struct Output: CardsViewModelingOutput {
        var cardsModel: AnyPublisher<[Card], Never>
        var onError: PassthroughSubject<Error, Never>
        var onOpenDetailsCard: PassthroughSubject<Card, Never>
    }
    
    lazy var input: Input = Input(didAddCard: didAddCard, didSelectItem: didSelectItem)
    
    lazy var output: Output = Output(cardsModel: cardsModel,
                                     onError: onError,
                                     onOpenDetailsCard: onOpenDetailsCard)
    
    // Input
    private let didAddCard = PassthroughSubject<Void, Never>()
    private let didSelectItem = PassthroughSubject<Card, Never>()
    
    // Output
    private var cardsModel: AnyPublisher<[Card], Never> {
        $cardModel.eraseToAnyPublisher()
    }
    private let onError = PassthroughSubject<Error, Never>()
    private let onOpenDetailsCard = PassthroughSubject<Card, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published private var cardModel: [Card] = []
    private let cdRepo: CDCardRepositoryProtocol
    
    init(cdRepo: CDCardRepositoryProtocol) {
        self.cdRepo = cdRepo
        bind()
    }
    
    private func bind() {
        cdRepo.retreiveCards()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.onError.send(error)
                }
            } receiveValue: { [weak self] model in
                self?.cardModel = model
            }
            .store(in: &cancellables)
        
        didAddCard
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.addCard()
            }
            .store(in: &cancellables)
        
        didSelectItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] card in
                self?.output.onOpenDetailsCard.send(card)
            }
            .store(in: &cancellables)
    }
    
    private func addCard() {
        let card = generateRandomCard()
        cdRepo.saveCard(with: card) { [weak self] result in
            switch result {
            case .success:
                print("\(card) was successfully created 🥶🥶🥶")
            case .failure(let error):
                self?.onError.send(error)
            }
        }
    }
}

extension CardsViewModel {
    private func generateRandomCard() -> Card {
        let cardType = CardType.allCases.randomElement() ?? .masterCard
        let cardNumber = generateCardNumber()
        return Card(cardType: cardType, cardNumber: cardNumber, cardCreatedAt: Date())
    }

    private func generateCardNumber() -> String {
        var number = ""
        for _ in 1...4 {
            number += String(format: "%04d", arc4random_uniform(10000))
        }
        return number
    }
}
