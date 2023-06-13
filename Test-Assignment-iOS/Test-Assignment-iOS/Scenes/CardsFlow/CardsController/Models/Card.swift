//
//  Card.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Foundation

enum CardType: String, Codable, CaseIterable {
    case visa, masterCard
}

struct Card: Codable, Hashable {
    let cardType: CardType
    let cardNumber: String
    let cardCreatedAt: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(cardCreatedAt)
    }
}
