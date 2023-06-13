//
//  UIView+AddSubviews.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 13.06.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
