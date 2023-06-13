//
//  CDRepository.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import RxSwift
import CoreData
import UIKit

protocol CDCardRepositoryProtocol {
    func retreiveCards() -> Observable<[Card]>
    func saveCard(with model: Card, completion: @escaping (Result<Void, Error>) -> Void)
}

class CDCardRepository: CDCardRepositoryProtocol {
    
    private var disposeBag: DisposeBag = DisposeBag()
    private var container: NSPersistentContainer?
    private var backgroundContext: NSManagedObjectContext?
    
    init() {
        loadPersistentContainer {
            // TODO: Need to replace with some logger
            print("Container loaded successfully 🤩🤩🤩")
        }
    }
    
    private func loadPersistentContainer(completion: @escaping () -> Void) {
        let createdContainer = NSPersistentContainer(name: "Test_Assignment_IOS")
        createdContainer.loadPersistentStores { [weak self] _, error in
            guard let self else { return }
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
                return
            }
            // Before we create current context we need to make sure that all stores are loaded
            container = createdContainer
            backgroundContext = container?.newBackgroundContext()
            completion()
        }
    }
    
    func retreiveCards() -> Observable<[Card]> {
        let cdPublisher = CDObservable(fetchRequest: CardEntity.fetchRequest(), context: backgroundContext ?? NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType))
        let mappedPublisher = cdPublisher.asObservable()
            .map { $0.compactMap { self.mapFrom(cardModel: $0) }}
            .map { cards in
                cards.sorted { $0.cardCreatedAt > $1.cardCreatedAt }
            }
        return mappedPublisher
    }
    
    func saveCard(with model: Card, completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundContext?.perform { [weak self] in
            guard let self, let backgroundContext = self.backgroundContext else { return }
            let cardEntity = CardEntity(context: backgroundContext)
            cardEntity.cardType = model.cardType.rawValue
            cardEntity.cardNumber = model.cardNumber
            cardEntity.cardCreatedAt = model.cardCreatedAt
            self.save { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func save(completion: ((Result<Void, Error>) -> Void)? = nil) {
        do {
            try backgroundContext?.save()
            print("Saved successfully in CoreData")
            completion?(.success(()))
        } catch {
            print(error.localizedDescription)
            completion?(.failure(error))
        }
    }
}

extension CDCardRepository {
    private func mapFrom(cardModel: CardEntity) -> Card? {
        guard let cardTypeString = cardModel.cardType,
              let cardNumber = cardModel.cardNumber,
              let cardCreatedAt = cardModel.cardCreatedAt,
              let cardType = CardType(rawValue: cardTypeString) else {
            print("Invalid or missing card type: \(cardModel.cardType ?? "nil")")
            return nil
        }
        return Card(cardType: cardType,
                    cardNumber: cardNumber,
                    cardCreatedAt: cardCreatedAt)
    }
}
