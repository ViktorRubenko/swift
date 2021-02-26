//
//  ViewController.swift
//  StormViewer
//
//  Created by Victor Rubenko on 24.02.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    let imageManager = ImagesManager()
    lazy var images = imageManager.images
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
        cell.textLabel?.text = images[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = images[indexPath.row]
            print("ok")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}

