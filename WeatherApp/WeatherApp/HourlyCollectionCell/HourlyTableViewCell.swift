//
//  HourlyTableViewCell.swift
//  WeatherApp
//
//  Created by Victor Rubenko on 07.01.2021.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "HourlyTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "HourlyTableViewCell", bundle: nil)
    }
    
}
