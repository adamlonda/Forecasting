//
//  SwinjectStoryboard.swift
//  Forecasting
//
//  Created by Adam Londa on 09/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        let swinject = defaultContainer
        
        swinject.register(LocationProtocol.self) { _ in
            LocationService()
        }
        
        swinject.register(CurrentWeatherProtocol.self) { _ in
            CurrentWeatherService()
        }
        
        swinject.register(WeatherForecastProtocol.self) { _ in
            WeatherForecastService()
        }
        
        swinject.storyboardInitCompleted(CurrentWeatherViewController.self) { r, c in
            c.locationService = r.resolve(LocationProtocol.self)
            c.weatherService = r.resolve(CurrentWeatherProtocol.self)
        }
        
        swinject.storyboardInitCompleted(WeatherForecastViewController.self) { r, c in
            c.locationService = r.resolve(LocationProtocol.self)
            c.weatherService = r.resolve(WeatherForecastProtocol.self)
        }
    }
}
