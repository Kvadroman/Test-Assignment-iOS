//
//  CardTableViewCell.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    
    static let identifier = "CardTableViewCell"
    
    func configure(with item: Card, and cardMask: CardMaskProtocol?) {
        var configuration = defaultContentConfiguration()
        if let image = UIImage(named: item.cardType.rawValue) {
            configuration.image = image.getScaledImage(with: 50)
        }
        configuration.text = cardMask?.mask(cardNumber: item.cardNumber)
        contentConfiguration = configuration
    }
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
}
