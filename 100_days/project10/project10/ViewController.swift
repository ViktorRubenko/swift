//
//  ViewController.swift
//  project10
//
//  Created by Victor Rubenko on 03.03.2021.
//

import UIKit

class ViewController: UICollectionViewController{
    
    override func viewDidLoad() {
        title = "Names to Faces"
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        cell.name.text = "1"
        return cell
    }
}

