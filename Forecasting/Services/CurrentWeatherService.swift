//
//  CurrentWeatherService.swift
//  Forecasting
//
//  Created by Adam Londa on 12/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import Alamofire
import RxSwift

class CurrentWeatherService: WeatherServiceBase, CurrentWeatherProtocol {
    private func parseCurrentWeather(from response: [String: Any]) throws -> CurrentWeather {
        guard
            let locationName = response["name"] as! String?,
            let weatherInfo = response["weather"] as! [[String: Any]]?,
            let mainInfo = response["main"] as! [String: Any]?,
            let windInfo = response["wind"] as! [String: Any]? else {
            throw NetworkingError.apiError
        }
        
        guard
            let weatherIcon = weatherInfo[0]["icon"] as! String?,
            let weatherDescription = weatherInfo[0]["main"] as! String?,
            let tempKelvin = mainInfo["temp"] as! NSNumber?,
            let humidity = mainInfo["humidity"] as! Int?,
            let pressure = mainInfo["pressure"] as! NSNumber?,
            let windSpeed = windInfo["speed"] as! NSNumber?,
            let windDegrees = windInfo["deg"] as! NSNumber? else {
            throw NetworkingError.apiError
        }
        
        let precipitation = response["rain"] as! [String : Any]?
        
        return CurrentWeather(
            locationName: locationName,
            icon: weatherIcon,
            description: weatherDescription,
            temperatureKelvin: tempKelvin.floatValue,
            humidity: humidity,
            precipitation: precipitation?["3h"] as! Int?,
            pressure: pressure.intValue,
            windSpeed: windSpeed.floatValue,
            windDegrees: windDegrees.intValue)
    }
    
    func getCurrentWeather(latitude: Double, longitude: Double) -> Observable<CurrentWeather> {
        return Observable<CurrentWeather>.create { (observer) -> Disposable in
            let url = "\(self.baseUrl)/weather?lat=\(latitude)&lon=\(longitude)&APPID=\(self.apiKey)"
            let request = Alamofire.request(url)
                .responseJSON { response in
                    do {
                        let data = try self.check(response)
                        observer.onNext(try self.parseCurrentWeather(from: data))
                    } catch {
                        observer.onError(error)
                    }
            }
            
            return Disposables.create(with: {
                request.cancel()
            })
        }
    }
}
