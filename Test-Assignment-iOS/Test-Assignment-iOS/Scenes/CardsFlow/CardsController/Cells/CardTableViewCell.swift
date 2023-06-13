//
//  CardTableViewCell.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    
    static let identifier = "CardTableViewCell"
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var bankNumberLabel: UILabel!
    
    func configure(with item: Card, and cardMask: CardMaskProtocol?) {
        if let image = UIImage(named: item.cardType.rawValue) {
            cardImageView.image = image.getScaledImage(with: 50)
        }
        bankNumberLabel.text = cardMask?.mask(cardNumber: item.cardNumber)
    }
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
}
