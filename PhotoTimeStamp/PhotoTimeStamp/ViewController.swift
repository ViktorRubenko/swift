//
//  ViewController.swift
//  PhotoTimeStamp
//
//  Created by Victor Rubenko on 06.03.2021.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PHPickerViewControllerDelegate {
    
    @IBOutlet weak var photoCollectionView: UICollectionView! {
        didSet {
            photoCollectionView.delegate = self
            photoCollectionView.dataSource = self
        }
    }
    var images = [UIImage]()
    var selectedCells = [Int]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else { fatalError() }
        cell.imageView.image = images[indexPath.row]
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
        let cell = collectionView.cellForItem(at: indexPath)
        if selectedCells.contains(indexPath.row) {
            selectedCells.removeAll(where: { $0 == indexPath.row })
            cell?.layer.borderColor = UIColor(white: 0.5, alpha: 0.2).cgColor
        } else {
            selectedCells.append(indexPath.row)
            cell?.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        // Do any additional setup after loading the view.
    }
    
    @objc func importPicture() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .current
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                    DispatchQueue.main.async {
                        guard let image = object as? UIImage else { return }
                        self!.images.append(image)
                        self!.dismiss(animated: true, completion: nil)
                        self!.photoCollectionView.reloadData()
                    }
                }
            }
        }
    }


}

