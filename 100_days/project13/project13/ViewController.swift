//
//  ViewController.swift
//  project13
//
//  Created by Victor Rubenko on 07.03.2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var intensity: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    var currentImage: UIImage! {
        didSet {
            imageView.image = currentImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))
    }
    
    @objc func importImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true, completion: nil)
        
        currentImage = image
    }


    @IBAction func changeFilter(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
    }
    @IBAction func intensityChanged(_ sender: Any) {
    }
}

