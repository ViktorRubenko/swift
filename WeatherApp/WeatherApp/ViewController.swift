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

enum WeatherAppError: Error {
    case requestFailed
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    
    @IBOutlet var table: UITableView!

    var models = [Step]()
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    let api_key = "e41cb2ac3eef6ce33f44bd481da7d890"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBlue
        
        table.backgroundColor = .clear
        table.rowHeight = 44.0
        // Register 2 cells
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
        }
        requestWeatherForLocation()
    }

    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let lon = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        getWeatherForecase(lat: lat, lon: lon)
        
    }
    
    func getWeatherForecase<T>(lat: T, lon: T){
        
        let units = "metric"
        
        if let url = URL(
            string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=\(units)&appid=\(api_key)"
        ) {
            URLSession.shared.dataTask(with: url) {data, response, error in
                if let data = data {
                    do {
                        // Clear models if user update forecast
                        if !self.models.isEmpty {
                            self.models.removeAll()
                        }
                        let result = try JSONDecoder().decode(Response.self, from: data)
                        self.models.append(contentsOf: result.list)
                        DispatchQueue.main.async {
                            self.table.reloadData()
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            self.showAlert(title: "Error", message: "\(error)")
                        }
                    }
                }
            }.resume()
        } else {
            print("something went wrong")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


struct Response: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [Step]
    }

struct Step: Codable {
    let dt: Int // UTC time
    let main: MainInfo
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Float
    let rain: Rain?
    let sys: Sys
    let dt_txt: String
    
    struct MainInfo: Codable {
        let temp: Float
        let feels_like: Float
        let temp_min: Float
        let temp_max: Float
        let pressure: Float
        let sea_level: Float
        let grnd_level: Float
        let humidity: Float
        let temp_kf: Float
    }
    
    struct Weather: Codable {
        /*
         id:
            2XX - Thunderstorm
            3XX - Drizzle
            5XX - Rain
            6XX - Snow
            7XX - Atmospere
            800 - Clear
            80X - Clouds
         */
        let id: Int
        let main: String
        let description: String
        let icon: String

    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct Wind: Codable {
        let speed: Float
        let deg: Int
    }
    
    struct Rain: Codable {
        let th: Float
        enum CodingKeys: String, CodingKey {
            case th = "3h"
        }
    }
    
    struct Sys: Codable {
        let pod: String
    }
    
    
    
}
