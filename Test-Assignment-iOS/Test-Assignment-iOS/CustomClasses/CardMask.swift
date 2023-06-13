//
//  CardMask.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Foundation

protocol DetailsCardMaskProtocol {
    func mask(detailsCardNumber: String) -> String
}

protocol CardMaskProtocol {
    func mask(cardNumber: String) -> String
 }

final class CardMask: CardMaskProtocol, DetailsCardMaskProtocol {
    func mask(cardNumber: String) -> String {
        let lastFourDigits = String(cardNumber.suffix(4))
        let maskedNumber = String(repeating: "*", count: 12) + lastFourDigits
        let spacedNumber = insertSpaces(every: 4, into: maskedNumber)
        return spacedNumber
    }

    func mask(detailsCardNumber: String) -> String {
        let lastFourDigits = String(detailsCardNumber.suffix(4))
        let maskedNumber = String(repeating: "*", count: 4) + " " + lastFourDigits
        return maskedNumber
    }

    private func insertSpaces(every n: Int, into string: String) -> String {
        var result = ""
        string.enumerated().forEach { index, character in
            if index != 0 && index % n == 0 {
                result += " "
            }
            result.append(character)
        }
        return result
    }
}
