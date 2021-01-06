//
//  ViewController.swift
//  ImageViewer
//
//  Created by Victor Rubenko on 04.01.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    // empty array of Strings
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Image Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Do any additional setup after loading the view.
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl"){
                // load a picture
                self.pictures.append(item)
            }
        }
        self.pictures.sort()
        print(pictures)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.imageIndex = indexPath.row
            vc.picturesCount = self.pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

