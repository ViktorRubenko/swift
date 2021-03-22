//
//  DetailPhotoView.swift
//  PhotoTimeStamp
//
//  Created by Victor Rubenko on 22.03.2021.
//

import UIKit

class DetailPhotoView: UIViewController {
    
    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = image {
            imageView.image = img
        }
    }

}
