//
//  CassiniViewController.swift
//  ImagesScroll
//
//  Created by Victor Rubenko on 19.02.2021.
//

import UIKit


class CassiniViewController: UIViewController {
    
    let NASAURLStrings: Dictionary<String, URL?> = [
        "Cassini" : URL(string: "https://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg"),
        "Earth" : URL(string:"https://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg"),
        "Saturn" : URL(string:"https://www.nasa.gov/sites/default/files/saturn_collage.jpg")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            print(identifier)
            if let url = NASAURLStrings[identifier] {
                if let imageVC = segue.destination as? ImageViewController {
                    print("send url")
                    imageVC.imageURL = url
                    imageVC.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }

}
