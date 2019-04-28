//
//  WeatherForecast.swift
//  Forecasting
//
//  Created by Adam Londa on 23/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import Foundation

enum TimeHorizon {
    case today, tomorrow
    case twoDays, threeDdays
    case fourDays, fiveDays
    case other
}

struct ForecastItem {
    let icon: String
    let description: String
    let temperatureKelvin: Float
    let dateTime: Date
    
    init(icon: String, description: String, temperatureKelvin: Float, dateTime: Date) {
        self.icon = icon
        self.description = description
        self.temperatureKelvin = temperatureKelvin
        self.dateTime = dateTime
    }
}

struct WeatherForecast {
    let nextFiveDays: [TimeHorizon: [ForecastItem]]
    
    init(nextFiveDays: [TimeHorizon: [ForecastItem]]) {
        self.nextFiveDays = nextFiveDays
    }
}
