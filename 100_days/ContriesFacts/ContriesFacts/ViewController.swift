//
//  ViewController.swift
//  ContriesFacts
//
//  Created by Victor Rubenko on 13.03.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var countriesData: CountriesData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        activityIndicator.startAnimating()
        let nib = UINib.init(nibName: "CountryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CountryCell")
        title = "Countries Facts"
        loadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailCountryViewController {
            vc.country = countriesData!.countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as? CountryCell else { fatalError() }
        cell.countryName.text = countriesData?.countries[indexPath.row].name
        if let alpha2Code = countriesData?.countries[indexPath.row].alpha2Code {
            cell.flagImage.image = UIImage(named: "flag_sd_\(alpha2Code.uppercased())")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesData?.countries.count ?? 0
    }

    func loadData() {
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            self!.countriesData = CountriesData()
            DispatchQueue.main.async {
                [weak self] in
                print("reload data")
                self!.activityIndicator.stopAnimating()
                self!.tableView.reloadData()
            }
        }
    }
}

