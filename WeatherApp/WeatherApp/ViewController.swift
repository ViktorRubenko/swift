//
//  ViewController.swift
//  WeatherApp
//
//  Created by Victor Rubenko on 06.01.2021.
//

import UIKit
import CoreLocation

// Location: CoreLocation
// tableView
// custom cell: collection view
// API / request data

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    @IBOutlet var table: UITableView!
    
    var models = [Weather]()
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register 2 cells
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }

    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        print("\(long) | \(lat)")
    }
    
}

struct Weather {
    
}
