//
//  TableViewController.swift
//  
//
//  Created by Victor Rubenko on 25.02.2021.
//

import UIKit

class CollectionController: UICollectionViewController {
    
    let imageManager = ImagesManager()
    lazy var images = imageManager.images
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(images)
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(images)
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = images[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StormCell", for: indexPath) as? StormCell else { fatalError() }
        cell.name.text = images[indexPath.row]
        return cell
    }
}
