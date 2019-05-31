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
    let icon: String
    let description: String
    let temperatureKelvin: Float
    let dateTime: Date
    
    init(icon: String, description: String, temperatureKelvin: Float, dateTime: Date) {
        self.icon = icon
        self.description = description
        self.temperatureKelvin = temperatureKelvin
        self.dateTime = dateTime
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
