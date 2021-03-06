import UIKit


class DetailViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var imageIndex = 0
    weak var model: Model!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    
    var lastZoomScale: CGFloat = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isToolbarHidden = true
        
        let item = UIBarButtonItem.init()
        item.title = "..."
        item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)], for: .normal)
        item.style = .plain
        item.target = self
        item.action = #selector(showActions)
        navigationItem.rightBarButtonItem = item
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipeLeftRecognizer.direction = .left
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipeLeftRecognizer.direction = .right
        view.addGestureRecognizer(swipeLeftRecognizer)
        view.addGestureRecognizer(swipeRightRecognizer)
    }
    
    @objc func showActions() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Remove", style: .default, handler: { (_) in
            self.model.infos.remove(at: self.imageIndex)
            self.imageIndex -= 1
            if self.imageIndex >= 0 {
                self.imageView.image = self.model.infos[self.imageIndex].image
                self.updateZoom()
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    
    
    @objc func swipeHandler(_ gestureRecignizer: UISwipeGestureRecognizer) {
        let location = gestureRecignizer.location(in: imageView)
        print(location)
        print(imageIndex)
        if gestureRecignizer.state == .ended {
            switch gestureRecignizer.direction {
            case .left:
                if imageIndex < model.infos.count - 1 {
                    imageIndex += 1
                    imageView.image = model.infos[imageIndex].image
                    updateZoom()
                }
            case .right:
                if imageIndex > 0 {
                    imageIndex -= 1
                    imageView.image = model.infos[imageIndex].image
                    updateZoom()
                }
            default:
                return
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imageView.image = model.infos[imageIndex].image
        scrollView.delegate = self
        updateZoom()
    }
    
    // Update zoom scale and constraints with animation.
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateZoom()
        }, completion: nil)
    }
    
    func updateConstraints() {
        if let image = imageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            let viewWidth = scrollView.bounds.size.width
            let viewHeight = scrollView.bounds.size.height
            
            // center image if it is smaller than the scroll view
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            
            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding
            
            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding
            
            view.layoutIfNeeded()
        }
    }
    
    // Zoom to show as much image as possible unless image is smaller than the scroll view
    fileprivate func updateZoom() {
        if let image = imageView.image {
            var minZoom = min(scrollView.bounds.size.width / image.size.width,
                              scrollView.bounds.size.height / image.size.height)
            
            if minZoom > 1 { minZoom = 1 }
            
            scrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale { minZoom += 0.000001 }
            
            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
        }
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}

