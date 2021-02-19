//
//  ImageViewController.swift
//  ImagesScroll
//
//  Created by Victor Rubenko on 19.02.2021.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollVIew: UIScrollView! {
        didSet {
            scrollVIew.delegate = self
            scrollVIew.minimumZoomScale = 0.5
            scrollVIew.maximumZoomScale = 2.0
            scrollVIew.addSubview(imageView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var imageURL: URL? {
        didSet {
            print("imageURL is set")
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private var imageView = UIImageView()
    private var image: UIImage? {
        get {
            return imageView.image
        }
        
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollVIew?.contentSize = imageView.frame.size
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            print("get url")
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                print("try to load")
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let dateContents = urlContents {
                        self?.image = UIImage(data: dateContents)
                    }
                }
            }
        }
    }
}
