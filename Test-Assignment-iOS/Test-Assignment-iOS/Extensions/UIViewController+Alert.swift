//
//  UIViewController+Alert.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 13.06.2023.
//

import UIKit

extension UIViewController {
    func showToast(message: String, seconds: Double, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true, completion: completion)
        }
    }
}
