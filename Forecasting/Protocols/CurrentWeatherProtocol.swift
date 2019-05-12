//
//  CurrentWeatherProtocol.swift
//  Forecasting
//
//  Created by Adam Londa on 12/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import RxSwift

protocol CurrentWeatherProtocol {
    func getCurrentWeather(latitude: Double, longitude: Double) -> Observable<CurrentWeather>
}
