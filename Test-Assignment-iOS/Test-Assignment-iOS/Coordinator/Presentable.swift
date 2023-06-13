//
//  Presentable.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import UIKit

public protocol Presentable {
    func toPresentable() -> UIViewController
}

extension UIViewController: Presentable {
    public func toPresentable() -> UIViewController {
        return self
    }
}
