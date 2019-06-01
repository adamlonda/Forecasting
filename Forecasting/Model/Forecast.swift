//
//  Forecast.swift
//  Forecasting
//
//  Created by Adam Londa on 23/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import Foundation

enum TimeHorizon: Int {
    case today = 0, tomorrow = 1
    case twoDays = 2, threeDdays = 3
    case fourDays = 4, fiveDays = 5
    case other = 6
    
    func getLabel() -> String {
        switch self {
        case .today:
            return "Today"
        case .tomorrow:
            return "Tomorrow"
        case .other:
            return "Other"
        default:
            return "In \(self.rawValue) days"
        }
    }
}

struct ForecastItem: Decodable {
    enum ForecastItemKeys: String, CodingKey {
        case dateTime = "dt"
        case mainInfo = "main"
        case weatherInfo = "weather"
    }
    
    //MARK: Kelvin temperature
    struct MainInfo: Decodable {
        enum MainInfoKeys: String, CodingKey {
            case temperatureKelvin = "temp"
        }
        
        let temperatureKelvin: Float
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MainInfoKeys.self)
            let temperatureKelvin = try container.decode(Float.self, forKey: .temperatureKelvin)
            self.init(temperatureKelvin: temperatureKelvin)
        }
        
        init(temperatureKelvin: Float) {
            self.temperatureKelvin = temperatureKelvin
        }
    }
    
    //MARK: Icon & description
    struct WeatherInfo: Decodable {
        enum WeatherInfoKeys: String, CodingKey {
            case icon = "icon"
            case description = "main"
        }
        
        let icon: String
        let description: String
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: WeatherInfoKeys.self)
            let icon = try container.decode(String.self, forKey: .icon)
            let description = try container.decode(String.self, forKey: .description)
            self.init(icon: icon, description: description)
        }
        
        init(icon: String, description: String) {
            self.icon = icon
            self.description = description
        }
    }
    
    private let mainInfo: MainInfo
    private let weatherInfo: WeatherInfo
    
    var temperatureKelvin: Float {
        get {
            return mainInfo.temperatureKelvin
        }
    }
    
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
    
//    let icon: String
//    let description: String
//    let temperatureKelvin: Float
    let dateTime: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ForecastItemKeys.self)
        let dateTime = try container.decode(Date.self, forKey: .dateTime)
        let mainInfo = try container.decode(MainInfo.self, forKey: .mainInfo)
        let weatherInfo = try container.decode(WeatherInfo.self, forKey: .weatherInfo)
        throw fatalError("Not implemented")
    }
    
    init(
//        icon: String,
//         description: String,
//         temperatureKelvin: Float,
         dateTime: Date,
         mainInfo: MainInfo,
         weatherInfo: WeatherInfo) {
//        self.icon = icon
//        self.description = description
//        self.temperatureKelvin = temperatureKelvin
        self.dateTime = dateTime
        self.mainInfo = mainInfo
        self.weatherInfo = weatherInfo
    }
}

struct Forecast {
    let timeHorizon: TimeHorizon
    let items: [ForecastItem]
    
    init(timeHorizon: TimeHorizon, items: [ForecastItem]) {
        self.timeHorizon = timeHorizon
        self.items = items
    }
}
