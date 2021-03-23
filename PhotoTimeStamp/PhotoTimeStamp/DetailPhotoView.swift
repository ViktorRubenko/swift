//
//  DetailPhotoView.swift
//  PhotoTimeStamp
//
//  Created by Victor Rubenko on 22.03.2021.
//

import UIKit

class DetailPhotoView: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.maximumZoomScale = 3
            scrollView.minimumZoomScale = 0.2
            scrollView.bouncesZoom = true
            scrollView.contentMode = .scaleAspectFit
        }
    }
    var image: UIImage?
    var imageView: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = image {
            imageView = UIImageView(image: img)
            scrollView.addSubview(imageView!)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView!
    }
    

}
