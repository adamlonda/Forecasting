//
//  WeatherForecastService.swift
//  Forecasting
//
//  Created by Adam Londa on 23/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import RxAlamofire
import RxSwift

class WeatherForecastService: WeatherServiceBase, WeatherForecastProtocol {
//    private func parseWeatherForecast(from response: [String: Any]) throws -> [ForecastItem] {
//        guard let forecastList = response["list"] as! [[String: Any]]? else {
//            throw NetworkingError.apiError
//        }
//
//        let forecastItems = try forecastList.map({ listItem -> ForecastItem in
//            guard let unixUtc = listItem["dt"] as! Double?,
//                let main = listItem["main"] as! [String: Any]?,
//                let weather = listItem["weather"] as! [[String: Any]]? else {
//                    throw NetworkingError.apiError
//            }
//
//            guard let tempKelvin = main["temp"] as! NSNumber?,
//                let icon = weather[0]["icon"] as! String?,
//                let description = weather[0]["main"] as! String? else {
//                    throw NetworkingError.apiError
//            }
//
//            return ForecastItem(
//                icon: icon,
//                description: description,
//                temperatureKelvin: tempKelvin.floatValue,
//                dateTime: Date(timeIntervalSince1970: unixUtc))
//        })
//
//        return forecastItems
//    }
    
    func getWeatherForecast(latitude: Double, longitude: Double) -> Observable<[Forecast]> {
        let url = "\(self.baseUrl)/forecast?lat=\(latitude)&lon=\(longitude)&APPID=\(self.apiKey)"
//        return RxAlamofire.requestJSON(.get, url)
//            .map({ [weak self] (response, json) in
//                if (self?.check(response) == true), let data = json as? [String: Any] {
//                    let result = try self?.parseWeatherForecast(from: data)
//                    if result != nil {
//                        return result!
//                    }
//                }
//                throw NetworkingError.apiError
//            })
        
        return RxAlamofire.requestData(.get, url)
            .map({ [weak self] (response, data) in
                if (self?.check(response) == true) {
                    let forecastInfo = try JSONDecoder().decode(ForecastInfo.self, from: data)
                    let today = Date()
                    let grouping = Dictionary(grouping: forecastInfo.items, by: {
                        $0.dateTime.getTimeHorizon(from: today)
                    })
    
                    return grouping.map({ (key, values) in
                        return Forecast(timeHorizon: key, items: values)
                    })
                }
                throw NetworkingError.apiError
            })
    }
}
