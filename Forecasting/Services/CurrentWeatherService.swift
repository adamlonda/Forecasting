//
//  CurrentWeatherService.swift
//  Forecasting
//
//  Created by Adam Londa on 12/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import RxAlamofire
import RxSwift

class CurrentWeatherService: WeatherServiceBase, CurrentWeatherProtocol {
    func getCurrentWeather(latitude: Double, longitude: Double) -> Observable<CurrentWeather> {
        let url = "\(self.baseUrl)/weather?lat=\(latitude)&lon=\(longitude)&APPID=\(self.apiKey)"
        return RxAlamofire.requestData(.get, url)
            .map({ [weak self] (response, data) in
                if (self?.check(response) == true) {
                    return try JSONDecoder().decode(CurrentWeather.self, from: data)
                }
                throw CommonError.apiError
            })
    }
}
