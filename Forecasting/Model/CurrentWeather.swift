//
//  CurrentWeather.swift
//  Forecasting
//
//  Created by Adam Londa on 12/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

struct CurrentWeather: Decodable {
    struct Descriptives: Decodable {
        enum DescriptivesKeys: String, CodingKey {
            case written = "main"
            case icon = "icon"
        }
        
        let written: String
        let icon: String
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DescriptivesKeys.self)
            let written = try container.decode(String.self, forKey: .written)
            let icon = try container.decode(String.self, forKey: .icon)
            self.init(written: written, icon: icon)
        }
        
        init(written: String, icon: String) {
            self.written = written
            self.icon = icon
        }
    }
    
    struct WeatherData: Decodable {
        enum WeatherDataKeys: String, CodingKey {
            case temperatureKelvin = "temp"
            case pressure = "pressure"
            case humidity = "humidity"
        }
        
        let temperatureKelvin: Float
        let pressure: Int
        let humidity: Int
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: WeatherDataKeys.self)
            let temperatureKelvin = try container.decode(Float.self, forKey: .temperatureKelvin)
            let pressure = try container.decode(Int.self, forKey: .pressure)
            let humidity = try container.decode(Int.self, forKey: .humidity)
            
            self.init(
                temperatureKelvin: temperatureKelvin,
                pressure: pressure,
                humidity: humidity)
        }
        
        init(temperatureKelvin: Float, pressure: Int, humidity: Int) {
            self.temperatureKelvin = temperatureKelvin
            self.pressure = pressure
            self.humidity = humidity
        }
    }
    
    struct WindInfo: Decodable {
        enum WindInfoKeys: String, CodingKey {
            case speed = "speed"
            case directionDegree = "deg"
        }
        
        let speed: Float
        let directionDegree: Int
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: WindInfoKeys.self)
            let speed = try container.decode(Float.self, forKey: .speed)
            let directionDegree = try container.decode(Int.self, forKey: .directionDegree)
            self.init(speed: speed, directionDegree: directionDegree)
        }
        
        init(speed: Float, directionDegree: Int) {
            self.speed = speed
            self.directionDegree = directionDegree
        }
    }
    
    struct RainInfo: Decodable {
        enum RainInfoKeys: String, CodingKey {
            case threeHours = "3h"
        }
        
        let mmVolume: Int
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: RainInfoKeys.self)
            let mmVolume = try container.decode(Int.self, forKey: .threeHours)
            self.init(mmVolume: mmVolume)
        }
        
        init(mmVolume: Int) {
            self.mmVolume = mmVolume
        }
    }
    
    let locationName: String
    
    private let descriptives: Descriptives
    private let weatherData: WeatherData
    private let windInfo: WindInfo
    private let rainInfo: RainInfo?
    
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
    
    var temperatureKelvin: Float {
        get {
            return weatherData.temperatureKelvin
        }
    }
    
    var pressure: Int {
        get {
            return weatherData.pressure
        }
    }
    
    var humidity: Int {
        get {
            return weatherData.humidity
        }
    }
    
    var windSpeed: Float {
        get {
            return windInfo.speed
        }
    }
    
    var windDegrees: Int {
        get {
            return windInfo.directionDegree
        }
    }
    
    var mmRainVolume: Int? {
        get {
            return rainInfo?.mmVolume
        }
    }
    
    enum CurrentWeatherKeys: String, CodingKey {
        case locationName = "name"
        case descriptives = "weather"
        case weatherData = "main"
        case windInfo = "wind"
        case rainInfo = "rain"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CurrentWeatherKeys.self)
        
        let locationName = try container.decode(String.self, forKey: .locationName)
        let descriptives = try container.decode([Descriptives].self, forKey: .descriptives)
        let weatherData = try container.decode(WeatherData.self, forKey: .weatherData)
        let windInfo = try container.decode(WindInfo.self, forKey: .windInfo)
        
        let rainInfo: RainInfo?
        do {
            rainInfo = try container.decode(RainInfo?.self, forKey: .rainInfo)
        } catch {
            rainInfo = nil
        }
        
        self.init(locationName: locationName,
                  descriptives: descriptives[0],
                  weatherData: weatherData,
                  windInfo: windInfo,
                  rainInfo: rainInfo)
    }
    
    init(locationName: String,
         descriptives: Descriptives,
         weatherData: WeatherData,
         windInfo: WindInfo,
         rainInfo: RainInfo?)
    {
        self.locationName = locationName
        self.descriptives = descriptives
        self.weatherData = weatherData
        self.windInfo = windInfo
        self.rainInfo = rainInfo
    }
}
