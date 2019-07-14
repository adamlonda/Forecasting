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

struct TemperatureInfo: Decodable {
    enum TemperatureInfoKeys: String, CodingKey {
        case kelvin = "temp"
    }
    
    let kelvin: Float
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TemperatureInfoKeys.self)
        let kelvin = try container.decode(Float.self, forKey: .kelvin)
        self.init(kelvin: kelvin)
    }
    
    init(kelvin: Float) {
        self.kelvin = kelvin
    }
}

struct Descriptives: Decodable {
    enum DescriptivesKeys: String, CodingKey {
        case icon = "icon"
        case written = "main"
    }
    
    let icon: String
    let written: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DescriptivesKeys.self)
        let icon = try container.decode(String.self, forKey: .icon)
        let written = try container.decode(String.self, forKey: .written)
        self.init(icon: icon, written: written)
    }
    
    init(icon: String, written: String) {
        self.icon = icon
        self.written = written
    }
}

struct ForecastItem: Decodable {
    enum ForecastItemKeys: String, CodingKey {
        case dateTime = "dt"
        case temperatureInfo = "main"
        case descriptives = "weather"
    }
    
    private let temperatureInfo: TemperatureInfo
    private let descriptives: Descriptives
    
    var temperatureKelvin: Float {
        get {
            return temperatureInfo.kelvin
        }
    }
    
    var icon: String {
        get {
            return descriptives.icon
        }
    }
    
    var description: String {
        get {
            return descriptives.written
        }
    }

    let dateTime: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ForecastItemKeys.self)
        
        let unixUtc = try container.decode(Double.self, forKey: .dateTime)
        let dateTime = Date(timeIntervalSince1970: unixUtc)
        
        let temperatureInfo = try container.decode(TemperatureInfo.self, forKey: .temperatureInfo)
        let descriptives = try container.decode([Descriptives].self, forKey: .descriptives)
        
        self.init(dateTime: dateTime, temperatureInfo: temperatureInfo, descriptives: descriptives[0])
    }
    
    init(dateTime: Date, temperatureInfo: TemperatureInfo, descriptives: Descriptives) {
        self.dateTime = dateTime
        self.temperatureInfo = temperatureInfo
        self.descriptives = descriptives
    }
}

struct UngrouppedForecast: Decodable {
    enum UngrouppedForecastKeys: String, CodingKey {
        case items = "list"
    }
    
    let items: [ForecastItem]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UngrouppedForecastKeys.self)
        let items = try container.decode([ForecastItem].self, forKey: .items)
        self.init(items: items)
    }
    
    init(items: [ForecastItem]) {
        self.items = items
    }
}

struct ForecastGroup {
    let timeHorizon: TimeHorizon
    let items: [ForecastItem]
    
    init(timeHorizon: TimeHorizon, items: [ForecastItem]) {
        self.timeHorizon = timeHorizon
        self.items = items
    }
}
