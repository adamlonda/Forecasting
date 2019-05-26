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
        case weatherInfo = "weather"
    }
    
    struct WeatherInfo: Decodable {
        enum WeatherInfoKeys: String, CodingKey {
            case description = "main"
            case icon = "icon"
        }
        
        let description: String
        let icon: String
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: WeatherInfoKeys.self)
            let description = try container.decode(String.self, forKey: .description)
            let icon = try container.decode(String.self, forKey: .icon)
            self.init(description: description, icon: icon)
        }
        
        init(description: String, icon: String) {
            self.description = description
            self.icon = icon
        }
    }
    
    let locationName: String
    
    private let weatherInfo: WeatherInfo
//    let icon: String
//    let description: String
    
    var icon: String {
        get {
            return weatherInfo.icon
        }
    }
    
    var description: String {
        get {
            return weatherInfo.description
        }
    }
    
    let temperatureKelvin: Float
    let humidity: Int
    let precipitation: Int?
    let pressure: Int
    let windSpeed: Float
    let windDegrees: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CurrentWeatherKeys.self)
        let locationName = try container.decode(String.self, forKey: .locationName)
        let weatherInfo = try container.decode(WeatherInfo.self, forKey: .weatherInfo)
        fatalError("Not implemented")
    }
    
    init(locationName: String,
         weatherInfo: WeatherInfo,
//         icon: String,
//         description: String,
         temperatureKelvin: Float,
         humidity: Int,
         precipitation: Int?,
         pressure: Int,
         windSpeed: Float,
         windDegrees: Int) {
        self.locationName = locationName
        self.weatherInfo = weatherInfo
//        self.icon = icon
//        self.description = description
        self.temperatureKelvin = temperatureKelvin
        self.humidity = humidity
        self.precipitation = precipitation
        self.pressure = pressure
        self.windSpeed = windSpeed
        self.windDegrees = windDegrees
    }
}
