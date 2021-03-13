//
//  DetailCountryViewController.swift
//  ContriesFacts
//
//  Created by Victor Rubenko on 13.03.2021.
//

import UIKit

class DetailCountryViewController: UIViewController {
    
    var country: Country?

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var population: UILabel!
    @IBOutlet weak var currencies: UILabel!
    @IBOutlet weak var languages: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let country = country else { return }
        title = country.name
        flagImage.image = UIImage(named: "flag_sd_\(country.alpha2Code)")
        countryName.text = "Native Name: \(country.nativeName)"
        capital.text = "Capital: \(country.capital)"
        population.text = "Population: \(country.population)"
        currencies.text = "Currencies: \(country.currencies.map( { $0.name! } ).joined(separator: ", "))"
        languages.text = "Languages: \(country.languages.map( { $0.name } ).joined(separator: ", "))"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    @objc func share() {
        let factString = """
        Facts about Belarus:
        1. Native name: \(country!.nativeName)
        2. Capital: \(country!.capital)
        3. Population: \(country!.population)
        4. Currencies: \(country!.currencies.map( { $0.name! } ).joined(separator: ", "))
        5. Languages: \(country!.languages.map( { $0.name } ).joined(separator: ", "))
        """
        let av = UIActivityViewController(activityItems: [factString], applicationActivities: nil)
        present(av, animated: true, completion: nil)
    }

}
