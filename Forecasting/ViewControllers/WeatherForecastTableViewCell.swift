//
//  WeatherForecastTableViewCell.swift
//  Forecasting
//
//  Created by Adam Londa on 02/05/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import UIKit

class WeatherForecastTableViewCell: UITableViewCell {
    @IBOutlet var forecastImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
