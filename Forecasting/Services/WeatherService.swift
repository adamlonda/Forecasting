//
//  WeatherService.swift
//  Forecasting
//
//  Created by Adam Londa on 12/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import Alamofire
import RxSwift

enum NetworkingError: Error {
    case emptyResponse
    case noResponseCode
    case invalidApiKey
    case apiError
}

class WeatherService: WeatherProtocol {
    private let apiKey = "4b41e86332361042c6ee97624f64b591"
    
    private func parseCurrentWeather(from response: [String: Any]) throws -> CurrentWeather {
        guard let locationName = response["name"] as! String? else {
            throw NetworkingError.apiError
        }
        
        return CurrentWeather(locationName: locationName)
    }
    
    func getCurrentWeather(latitude: Double, longitude: Double) -> Observable<CurrentWeather> {
        return Observable<CurrentWeather>.create { (observer) -> Disposable in
            let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&APPID=\(self.apiKey)"
            let request = Alamofire.request(url)
                .responseJSON { response in
                    guard response.result.error == nil else {
                        observer.onError(response.result.error!)
                        return
                    }
                    
                    guard let data = response.result.value as! [String : Any]? else {
                        observer.onError(NetworkingError.emptyResponse)
                        return
                    }
                    
                    guard let responseCode = data["cod"] as! Int? else {
                        observer.onError(NetworkingError.noResponseCode)
                        return
                    }
                    
                    do {
                        switch responseCode {
                        case 200:
                            observer.onNext(try self.parseCurrentWeather(from: data))
                        case 401:
                            throw NetworkingError.invalidApiKey
                        default:
                            throw NetworkingError.apiError
                        }
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
