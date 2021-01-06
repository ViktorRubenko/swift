//
//  ViewController.swift
//  WeatherApp
//
//  Created by Victor Rubenko on 06.01.2021.
//

import UIKit

// Location: CoreLocation
// tableView
// custom cell: collection view
// API / request data

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    @IBOutlet var table: UITableView!
    
    var models = [Weather]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
    }


}

struct Weather {
    
}
