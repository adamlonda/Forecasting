//
//  WeatherForecast.swift
//  Forecasting
//
//  Created by Adam Londa on 23/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import Foundation

struct ForecastItem {
    let icon: String
    let description: String
    let temperatureKelvin: Float
    let time: Date
    
    init(icon: String, description: String, temperatureKelvin: Float, time: Date) {
        self.icon = icon
        self.description = description
        self.temperatureKelvin = temperatureKelvin
        self.time = time
    }
}

struct WeatherForecast {
    let list: [ForecastItem]
    
    init(list: [ForecastItem]) {
        self.list = list
    }
}
