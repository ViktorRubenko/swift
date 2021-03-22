//
//  ViewController.swift
//  PhotoTimeStamp
//
//  Created by Victor Rubenko on 06.03.2021.
//

import UIKit
import PhotosUI


struct TimeStampInfo {
    let creationDate: Date?
    let location: CLLocation?
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PHPickerViewControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var photoCollectionView: UICollectionView! {
        didSet {
            photoCollectionView.delegate = self
            photoCollectionView.dataSource = self
        }
    }
    var data = [(UIImage, TimeStampInfo)]()
    var selectedCells = [Int]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else { fatalError() }
        cell.imageView.image = data[indexPath.row].0
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
            cell?.layer.borderWidth = 1
            cell?.layer.borderColor = UIColor(white: 0.5, alpha: 0.2).cgColor
        } else {
            selectedCells.append(indexPath.row)
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    @objc func addTimeStamp() {
        
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy\nHH:mm"
            dateFormatter.locale = .current
            
            for selectedIndex in self!.selectedCells {
                var image = self!.data[selectedIndex].0
                let creationDate = self!.data[selectedIndex].1.creationDate!
                let text = NSAttributedString(string: dateFormatter.string(from: creationDate), attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                    NSAttributedString.Key.strokeColor: UIColor.black,
                    NSAttributedString.Key.strokeWidth: -1,
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 150)
                ])
                
                let renderer = UIGraphicsImageRenderer(size: image.size)
                let img = renderer.image(actions: { (_) in
                    image.draw(at: .zero)
                    text.draw(at: CGPoint(x: image.size.width * 0.05, y: image.size.height - image.size.height * 0.15))
                })
                self!.data[selectedIndex] = (img, self!.data[selectedIndex].1)
            }
            self!.selectedCells.removeAll()
            DispatchQueue.main.async {
                [weak self] in
                self!.photoCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(addTimeStamp))
        
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        photoCollectionView.addGestureRecognizer(pressGesture)
        pressGesture.minimumPressDuration = 0.5
        pressGesture.delegate = self
        pressGesture.delaysTouchesEnded = true
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .ended {
            return
        }
        
        let location = sender.location(in: photoCollectionView)
        if let indexPath = photoCollectionView.indexPathForItem(at: location) {
            guard let vc = storyboard?.instantiateViewController(identifier: "DetailPhotoView") as? DetailPhotoView else { return }
            vc.image = data[indexPath.row].0
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
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

        let myGroup = DispatchGroup()
        
        for result in results {
            myGroup.enter()
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    guard let image = image as? UIImage else { return }
                    let identifier = result.assetIdentifier
                    let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [identifier!], options: nil)
                    let creationDate = fetchResult[0].creationDate!
                    print(creationDate)
                    let location = fetchResult[0].location
                    self.data.append((image, TimeStampInfo(creationDate: creationDate, location: location)))
                    myGroup.leave()
                }
            }
        }
        
        myGroup.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            DispatchQueue.main.async {
                [weak self] in
                self!.photoCollectionView.reloadData()
            }
        }
    }
}

