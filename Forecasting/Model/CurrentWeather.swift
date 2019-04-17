//
//  CurrentWeather.swift
//  Forecasting
//
//  Created by Adam Londa on 12/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

struct CurrentWeather {
    let locationName: String
    let icon: String
    let description: String
    let temperatureKelvin: Float
    let humidity: Int
    
    init(locationName: String, icon: String, description: String, temperatureKelvin: Float, humidity: Int) {
        self.locationName = locationName
        self.icon = icon
        self.description = description
        self.temperatureKelvin = temperatureKelvin
        self.humidity = humidity
    }
}
