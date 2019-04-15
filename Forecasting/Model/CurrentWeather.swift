//
//  CurrentWeather.swift
//  Forecasting
//
//  Created by Adam Londa on 12/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

struct CurrentWeather {
    let locationName: String
    let description: String
    
    init(locationName: String, description: String) {
        self.locationName = locationName
        self.description = description
    }
}
