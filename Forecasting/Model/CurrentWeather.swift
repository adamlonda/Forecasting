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
        case mainInfo = "main"
        case windInfo = "wind"
        case rainInfo = "rain"
    }
    
    //MARK: Description & icon
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
    
    //MARK: Temperature, pressure & humidity
    struct MainInfo: Decodable {
        enum MainInfoKeys: String, CodingKey {
            case temperatureKelvin = "temp"
            case pressure = "pressure"
            case humidity = "humidity"
        }
        
        let temperatureKelvin: Float
        let pressure: Int
        let humidity: Int
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MainInfoKeys.self)
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
    
    //MARK: Wind speed & direction
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
    
    //MARK: Rain volume
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
    
    private let weatherInfo: WeatherInfo
    private let mainInfo: MainInfo
    private let windInfo: WindInfo
    private let rainInfo: RainInfo?
    
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
    
    var temperatureKelvin: Float {
        get {
            return mainInfo.temperatureKelvin
        }
    }
    
    var pressure: Int {
        get {
            return mainInfo.pressure
        }
    }
    
    var humidity: Int {
        get {
            return mainInfo.humidity
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CurrentWeatherKeys.self)
        
        let locationName = try container.decode(String.self, forKey: .locationName)
        let weatherInfo = try container.decode([WeatherInfo].self, forKey: .weatherInfo)
        let mainInfo = try container.decode(MainInfo.self, forKey: .mainInfo)
        let windInfo = try container.decode(WindInfo.self, forKey: .windInfo)
        
        let rainInfo: RainInfo?
        do {
            rainInfo = try container.decode(RainInfo?.self, forKey: .rainInfo)
        } catch {
            rainInfo = nil
        }
        
        self.init(locationName: locationName,
                  weatherInfo: weatherInfo[0],
                  mainInfo: mainInfo,
                  windInfo: windInfo,
                  rainInfo: rainInfo)
    }
    
    init(locationName: String,
         weatherInfo: WeatherInfo,
         mainInfo: MainInfo,
         windInfo: WindInfo,
         rainInfo: RainInfo?)
    {
        self.locationName = locationName
        self.weatherInfo = weatherInfo
        self.mainInfo = mainInfo
        self.windInfo = windInfo
        self.rainInfo = rainInfo
    }
}
