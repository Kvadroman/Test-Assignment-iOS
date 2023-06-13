//
//  CardsViewModel.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class CardsViewModel: CardsViewModeling {
    
    struct Input: CardsViewModelingInput {
        let didAddCard: AnyObserver<Void>
        let didSelectItem: AnyObserver<Card>
    }
    
    struct Output: CardsViewModelingOutput {
        let cardsModel: Observable<[Card]>
        let onError: Observable<Error>
        let onOpenDetailsCard: Observable<Card>
    }
    
    lazy var input: Input = Input(didAddCard: didAddCardSubject.asObserver(),
                                  didSelectItem: didSelectItemSubject.asObserver())
    lazy var output: Output = Output(cardsModel: cardModelSubject.asObservable(),
                                     onError: onErrorSubject.asObservable(),
                                     onOpenDetailsCard: onOpenDetailsCardSubject.asObservable())
    
    private let didAddCardSubject = PublishSubject<Void>()
    private let didSelectItemSubject = PublishSubject<Card>()
    
    private let cardModelSubject = PublishSubject<[Card]>()
    private let onErrorSubject = PublishSubject<Error>()
    private let onOpenDetailsCardSubject = PublishSubject<Card>()
    
    private let disposeBag = DisposeBag()
    private let cdRepo: CDCardRepositoryProtocol
    
    init(cdRepo: CDCardRepositoryProtocol) {
        self.cdRepo = cdRepo
        bind()
    }
    
    private func bind() {
        cdRepo.retreiveCards()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .next(let model):
                    self?.cardModelSubject.onNext(model)
                case .error(let error):
                    self?.onErrorSubject.onNext(error)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        didAddCardSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.addCard()
            })
            .disposed(by: disposeBag)
        
        didSelectItemSubject
            .observe(on: MainScheduler.instance)
            .bind(to: onOpenDetailsCardSubject)
            .disposed(by: disposeBag)
        
        cdRepo.retreiveCards()
            .bind(to: cardModelSubject)
            .disposed(by: disposeBag)
    }
    
    private func addCard() {
        let card = generateRandomCard()
        cdRepo.saveCard(with: card) { [weak self] result in
            switch result {
            case .success:
                print("\(card) was successfully created 🥶🥶🥶")
            case .failure(let error):
                self?.onErrorSubject.onNext(error)
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
