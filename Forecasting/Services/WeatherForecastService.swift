//
//  WeatherForecastService.swift
//  Forecasting
//
//  Created by Adam Londa on 23/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import Alamofire
import RxSwift

class WeatherForecastService: WeatherServiceBase, WeatherForecastProtocol {
    override func getResponseCode(from data: [String : Any]) throws -> Int {
        guard let responseCode = data["cod"] as! String? else {
            throw NetworkingError.noResponseCode
        }
        
        guard let responseCodeNum = Int(responseCode) else {
            throw NetworkingError.noResponseCode
        }
        
        return responseCodeNum
    }
    
    private func parseWeatherForecast(from response: [String: Any]) throws -> WeatherForecast {
        return WeatherForecast()
    }
    
    func getWeatherForecast(latitude: Double, longitude: Double) -> Observable<WeatherForecast> {
        return Observable<WeatherForecast>.create { (observer) -> Disposable in
            let url = "\(self.baseUrl)/forecast?lat=\(latitude)&lon=\(longitude)&APPID=\(self.apiKey)"
            let request = Alamofire.request(url)
                .responseJSON { response in
                    do {
                        let data = try self.check(response)
                        observer.onNext(try self.parseWeatherForecast(from: data))
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
