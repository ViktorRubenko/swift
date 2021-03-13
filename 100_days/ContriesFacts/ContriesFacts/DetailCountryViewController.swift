//
//  DetailCountryViewController.swift
//  ContriesFacts
//
//  Created by Victor Rubenko on 13.03.2021.
//

import UIKit

class DetailCountryViewController: UIViewController {
    
    var country: Country?

    @IBOutlet weak var flagImage: UIImageView! {
        didSet {
            flagImage.image = UIImage(named: "flag_sd_\(country!.alpha2Code)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
