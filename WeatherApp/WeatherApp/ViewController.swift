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
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: days[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    
    @IBOutlet var table: UITableView!

    var days = [Day]()
    var days_3h = [Step]()
    
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
                        // Clear days if user update forecast
                        if !self.days.isEmpty {
                            self.days.removeAll()
                        }
                        let result = try JSONDecoder().decode(Response.self, from: data)
                        self.days_3h.append(contentsOf: result.list)
                        print(self.days_3h)
                        self.days.append(contentsOf: self.calcWeatherForDays(from: result.list))
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
    
    func calcWeatherForDays(from steps: [Step]) -> [Day] {
        // Calculate weather for days from 3h forecasts
        var days = [Day]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        var prev_day_name = dateFormatter.string(from: Date(timeIntervalSince1970: Double(steps[0].dt)))
        
        var max_temps = [Float]()
        var min_temps = [Float]()
        var weathers = [String]()
        
        for step in steps {
            let day_name = dateFormatter.string(from: Date(timeIntervalSince1970: Double(step.dt)))
            if day_name != prev_day_name {
                let weather = calcMostFrequently(from: weathers)
                var id: Int
                switch weather {
                case "Thunderstorm":
                    id = 200
                case "Drizzle":
                    id = 300
                case "Rain":
                    id = 500
                case "Snow":
                    id = 600
                case "Clouds":
                    id = 801
                case "Clear":
                    id = 800
                default:
                    id = 700
                }
                
                days.append(Day(day_name: prev_day_name, weather: weather, id: id, max_temp: round(max_temps.reduce(0.0, +) / Float(max_temps.count)), min_temp: round(min_temps.reduce(0.0, +) / Float(min_temps.count))))
                max_temps.removeAll()
                min_temps.removeAll()
                weathers.removeAll()
                prev_day_name = day_name
            }
            weathers.append(step.weather[0].main)
            max_temps.append(step.main.temp_max)
            min_temps.append(step.main.temp_min)
        }
        return days
    }
}
    
func calcMostFrequently(from array: [String]) -> String {
    var frequency: [String:Int] = [:]
    
    for x in array {
        frequency[x] = (frequency[x] ?? 0) + 1
    }
    
    return frequency.sorted(by: { $0.0 > $1.0 })[0].0
    
}

struct Day {
    let day_name: String
    let weather: String
    let id: Int
    let max_temp: Float
    let min_temp: Float
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
