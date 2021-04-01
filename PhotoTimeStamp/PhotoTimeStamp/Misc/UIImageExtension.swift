//
//  UIImageExtension.swift
//  PhotoTimeStamp
//
//  Created by Victor Rubenko on 01.04.2021.
//

import UIKit

extension UIImage {
    func compress() -> UIImage {
        var prefSize = (height: CGFloat(0), width: CGFloat(0))
        if self.size.height >= self.size.width {
            let coef = self.size.width / self.size.height
            prefSize = (height: 1000, width: self.size.width * coef)
        } else {
            let coef = self.size.height / self.size.width
            prefSize = (height: self.size.height * coef, width: 1000)
        }
        let widthScaleRatio = prefSize.width / self.size.width
        let heightScaleRatio = prefSize.height / self.size.height
        let scaleFactor = min(widthScaleRatio, heightScaleRatio)
        
        let scaledImageSize = CGSize(
            width: self.size.width * scaleFactor,
            height: self.size.height * scaleFactor
        )
        
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
            
        let imageData = scaledImage.jpegData(compressionQuality: 0.1)!
            
        return UIImage(data: imageData)!
    }
}
