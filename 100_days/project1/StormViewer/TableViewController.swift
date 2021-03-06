//
//  TableViewController.swift
//  
//
//  Created by Victor Rubenko on 25.02.2021.
//

import UIKit

class TableViewController: UITableViewController {
    
    let imageManager = ImagesManager()
    lazy var images = imageManager.images
    var shownCount = [String: Int]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let savedCount = defaults.value(forKey: "shownCount") as? [String:Int] {
            shownCount = savedCount
        } else {
            print("Failed to load shownCount")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
        cell.textLabel?.text = images[indexPath.row]
        cell.detailTextLabel?.text = "Shown: \(shownCount[images[indexPath.row]] ?? 0)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            if let count = shownCount[images[indexPath.row]] {
                shownCount[images[indexPath.row]] = count + 1
            } else {
                shownCount[images[indexPath.row]] = 1
            }
            tableView.reloadData()
            save()
            vc.selectedImage = images[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        defaults.setValue(shownCount, forKey: "shownCount")
    }
}
