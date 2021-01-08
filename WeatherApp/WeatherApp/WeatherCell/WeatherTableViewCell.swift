//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Victor Rubenko on 07.01.2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var maxTemp: UILabel!
    @IBOutlet var minTemp: UILabel!
    @IBOutlet var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "WeatherTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: Step) {
        self.maxTemp.text = "\(Int(model.main.temp_max))"
        self.minTemp.text = "\(Int(model.main.temp_min))"
        self.weatherLabel.text = model.weather[0].main
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM HH:mm"
        self.dateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(model.dt)))
        
        var icon_name: String?
        switch model.weather[0].id {
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
        case 200..<400, 500..<600:
            icon_name = "rain"
        case 600..<700:
            icon_name = "snow"
        case 801..<900:
            icon_name = "cloud"
        default:
            icon_name = "clear"
        }
        self.iconImageView.image = UIImage(named: icon_name!)
    }
    
}
