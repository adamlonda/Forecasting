//
//  WeatherForecastService.swift
//  Forecasting
//
//  Created by Adam Londa on 23/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import RxSwift

class WeatherForecastService: WeatherForecastProtocol {
    func getWeatherForecast(latitude: Double, longitude: Double) -> Observable<WeatherForecast> {
        fatalError("Not implemented")
    }
}
