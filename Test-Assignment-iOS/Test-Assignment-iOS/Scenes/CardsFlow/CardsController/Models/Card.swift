//
//  Card.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Foundation

enum CardType: String, CaseIterable {
    case visa, masterCard
}

struct Card: Hashable {
    let cardType: CardType
    let cardNumber: String
    let cardCreatedAt: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(cardCreatedAt)
    }
}

extension Card {
    static var defaultCard: Card {
        Card(cardType: .visa, cardNumber: "1234567891011121", cardCreatedAt: Date())
    }
}
