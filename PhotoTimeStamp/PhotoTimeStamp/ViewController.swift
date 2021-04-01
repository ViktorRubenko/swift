//
//  ViewController.swift
//  PhotoTimeStamp
//
//  Created by Victor Rubenko on 06.03.2021.
//

import UIKit
import PhotosUI


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PHPickerViewControllerDelegate {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoCollectionView: UICollectionView! {
        didSet {
            photoCollectionView.delegate = self
            photoCollectionView.dataSource = self
        }
    }
    var model = Model()
    var selectedCells = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeSelected))
        
        navigationController?.isToolbarHidden = false
        updateToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoCollectionView.reloadData()
        navigationController?.isToolbarHidden = false
        updateToolbar()
    }
    
    func updateToolbar() {
        if model.infos.isEmpty {
            toolbarItems = []
        } else {
            toolbarItems = [
                UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(sharePhotos)),
                UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(savePhotos)),
                UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem.init(barButtonSystemItem: .trash, target: self, action: #selector(removePhotos)),
                UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            ]
        }
    }
    
    func resizeImage(_ image: UIImage) -> UIImage {
        var prefSize = (height: CGFloat(0), width: CGFloat(0))
        if image.size.height >= image.size.width {
            let coef = image.size.width / image.size.height
            prefSize = (height: 1000, width: image.size.width * coef)
        } else {
            let coef = image.size.height / image.size.width
            prefSize = (height: image.size.height * coef, width: 1000)
        }
        let widthScaleRatio = prefSize.width / image.size.width
        let heightScaleRatio = prefSize.height / image.size.height
        let scaleFactor = min(widthScaleRatio, heightScaleRatio)
        
        let scaledImageSize = CGSize(
            width: image.size.width * scaleFactor,
            height: image.size.height * scaleFactor
        )
        
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
        
        return scaledImage
    }
    
    @objc func sharePhotos() {
        if selectedCells.isEmpty {
            let ac = UIAlertController(title: "Share Photos", message: "No photos selected, share all?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "YES", style: .default, handler: {
                [weak self] (_) in
                var images = [UIImage]()
                for info in self!.model.infos {
                    images.append(info.image.compress())
                }
                let activityController = UIActivityViewController(activityItems: images, applicationActivities: nil)
                self!.present(activityController, animated: true)
            }))
            ac.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    @objc func removePhotos() {
        if selectedCells.isEmpty {
            let ac = UIAlertController(title: "Remove Photos", message: "No photos selected, remove all?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "YES", style: .default, handler: {
                [weak self] (_) in
                self!.model.infos.removeAll()
                DispatchQueue.main.async {
                    self?.photoCollectionView.reloadData()
                    self?.updateToolbar()
                }
                let ac = UIAlertController(title: "All photos were removed", message: "", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self!.present(ac, animated: true, completion: nil)
            }))
            ac.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    @objc func savePhotos() {
        if selectedCells.isEmpty {
            let ac = UIAlertController(title: "Save Photos", message: "No photos selected, save all?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "YES", style: .default, handler: {
                [weak self] (_) in
                for info in self!.model.infos {
                    UIImageWriteToSavedPhotosAlbum(info.image, self, nil, nil)
                }
                let ac = UIAlertController(title: "All photos were saved to the Gallery", message: "", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self!.present(ac, animated: true, completion: nil)
            }))
            ac.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.infos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else { fatalError() }
        cell.imageView.image = model.infos[indexPath.row].thumbnail
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(white: 0.5, alpha: 0.2).cgColor
        cell.layer.cornerRadius = 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = photoCollectionView.bounds.width / 3.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "DetailPhotoView") as? DetailViewController else { return }
        vc.imageIndex = indexPath.row
        vc.model = model
        navigationController?.pushViewController(vc, animated: true)    }
    
    @objc func importPicture() {
        let photoLibrary = PHPhotoLibrary.shared()
        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        configuration.selectionLimit = 0
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        activityIndicator.startAnimating()
        if results.isEmpty {
            self.activityIndicator.stopAnimating()
        }
        self.model.addResults(
            results: results,
            action: {
                self.photoCollectionView.reloadData()
                self.updateToolbar()
            },
            complition: {
                print("end")
                self.activityIndicator.stopAnimating()
            }
        )
    }
}
