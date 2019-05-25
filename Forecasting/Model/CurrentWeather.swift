//
//  CurrentWeather.swift
//  Forecasting
//
//  Created by Adam Londa on 12/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

struct CurrentWeather: Decodable {
    enum CurrentWeatherKeys: String, CodingKey {
        case locationName = "name"
    }
    
    let locationName: String
    let icon: String
    let description: String
    let temperatureKelvin: Float
    let humidity: Int
    let precipitation: Int?
    let pressure: Int
    let windSpeed: Float
    let windDegrees: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CurrentWeatherKeys.self)
        let locationName: String = try container.decode(String.self, forKey: .locationName)
        fatalError("Not implemented")
    }
    
    init(locationName: String, icon: String, description: String, temperatureKelvin: Float, humidity: Int, precipitation: Int?, pressure: Int, windSpeed: Float, windDegrees: Int) {
        self.locationName = locationName
        self.icon = icon
        self.description = description
        self.temperatureKelvin = temperatureKelvin
        self.humidity = humidity
        self.precipitation = precipitation
        self.pressure = pressure
        self.windSpeed = windSpeed
        self.windDegrees = windDegrees
    }
}
