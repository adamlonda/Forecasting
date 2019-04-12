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
        
        swinject.register(WeatherProtocol.self) { _ in
            WeatherService()
        }
        
        swinject.storyboardInitCompleted(TodayViewController.self) { r, c in
            c.locationService = r.resolve(LocationProtocol.self)
            c.weatherService = r.resolve(WeatherProtocol.self)
        }
    }
}
