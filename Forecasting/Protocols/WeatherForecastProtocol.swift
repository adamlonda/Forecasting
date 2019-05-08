//
//  WeatherForecastProtocol.swift
//  Forecasting
//
//  Created by Adam Londa on 23/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import RxSwift

protocol WeatherForecastProtocol {
    func getWeatherForecast(latitude: Double, longitude: Double) -> Observable<[ForecastItem]>
}
