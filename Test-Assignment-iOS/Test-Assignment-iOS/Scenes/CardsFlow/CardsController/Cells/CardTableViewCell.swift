//
//  CardTableViewCell.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import Combine
import UIKit

class CardTableViewCell: UITableViewCell {
    
    static let identifier = "CardTableViewCell"
    
    var cancellables: Set<AnyCancellable> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
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
