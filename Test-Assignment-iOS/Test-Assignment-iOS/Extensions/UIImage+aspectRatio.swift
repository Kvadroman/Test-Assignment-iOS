//
//  UIImage+aspectRatio.swift
//  Test-Assignment-iOS
//
//  Created by Ивченко Антон on 12.06.2023.
//

import UIKit

extension UIImage {
    func getScaledImage(with targetWidth: CGFloat) -> UIImage {
        let aspectRatio = size.height / size.width
        let targetHeight = targetWidth * aspectRatio
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let scaledImage = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return scaledImage
    }
}
