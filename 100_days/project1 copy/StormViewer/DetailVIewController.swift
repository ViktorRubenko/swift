//
//  DetailVIewController.swift
//  
//
//  Created by Victor Rubenko on 24.02.2021.
//

import UIKit


class DetailViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.addSubview(imageView)
            scrollView.maximumZoomScale = 5.0
            scrollView.minimumZoomScale = 1.0
        }
    }
    var selectedImage: String?
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedImage = selectedImage {
            imageView.image = UIImage(named: selectedImage)
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
