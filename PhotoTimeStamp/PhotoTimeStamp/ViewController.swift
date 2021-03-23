//
//  ViewController.swift
//  PhotoTimeStamp
//
//  Created by Victor Rubenko on 06.03.2021.
//

import UIKit
import PhotosUI


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PHPickerViewControllerDelegate {
    
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
        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            //            UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(addTimeStamp)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
        ]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(model.infos.count)
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
        guard let vc = storyboard?.instantiateViewController(identifier: "DetailPhotoView") as? DetailPhotoView else { return }
        vc.image = model.infos[indexPath.row].image
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
        
        self.model.addResults(results: results, complition: {
            self.photoCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
        })
    }
}
