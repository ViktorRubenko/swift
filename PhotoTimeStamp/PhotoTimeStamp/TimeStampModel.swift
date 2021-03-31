//
//  TimeStampData.swift
//  PhotoTimeStamp
//
//  Created by Victor Rubenko on 24.03.2021.
//

import UIKit
import CoreLocation
import PhotosUI

struct TimeStampInfo {
    let originImage: UIImage
    let location: CLLocation?
    let creationDate: Date
}

struct TimeStampData {
    let image: UIImage
    var thumbnail: UIImage {
        let imageData = self.image.jpegData(compressionQuality: 1)!
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 500] as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithData(imageData as NSData, nil),
              let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options)
        else { return self.image }
        return UIImage(cgImage: image)
    }
    let info: TimeStampInfo
}


class Model {
    var infos = [TimeStampData]()
    
    func addResults(results: [PHPickerResult], complition: @escaping () -> Void = { return }) {
        DispatchQueue.global(qos: .userInitiated).async {
            for result in results {
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        guard let originImage = image as? UIImage else { return }
                        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [result.assetIdentifier!], options: nil)
                        let info = TimeStampInfo(originImage: originImage, location: fetchResult[0].location, creationDate: fetchResult[0].creationDate!)
                        self.infos.append(TimeStampData(image: self.addTimeStamp(info: info), info: info))
                        DispatchQueue.main.async {
                            complition()
                        }
                    }
                }
            }
        }
    }
    
    func addTimeStamp(info: TimeStampInfo) -> UIImage {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateFormatter.locale = .current
        
        let creationDate = info.creationDate
        let text = NSAttributedString(string: dateFormatter.string(from: creationDate), attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.strokeWidth: -1,
            NSAttributedString.Key.font: UIFont(name: "Futura", size: info.originImage.size.width * 0.045)!
        ])
        
        let image = info.originImage
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
        let img = renderer.image(actions: { (_) in
            image.draw(at: .zero)
            text.draw(at: CGPoint(x: image.size.width * 0.05, y: image.size.height - image.size.height * 0.15))
        })
        return img
    }
}
