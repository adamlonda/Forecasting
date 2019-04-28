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
        guard let forecastList = response["list"] as! [[String: Any]]? else {
            throw NetworkingError.apiError
        }
        
        let forecastItems = try forecastList.map({ listItem -> ForecastItem in
            guard let unixUtc = listItem["dt"] as! Double?,
                let main = listItem["main"] as! [String: Any]?,
                let weather = listItem["weather"] as! [[String: Any]]? else {
                throw NetworkingError.apiError
            }
            
            guard let tempKelvin = main["temp"] as! NSNumber?,
                let icon = weather[0]["icon"] as! String?,
                let description = weather[0]["main"] as! String? else {
                throw NetworkingError.apiError
            }
            
            return ForecastItem(
                icon: icon,
                description: description,
                temperatureKelvin: tempKelvin.floatValue,
                dateTime: Date(timeIntervalSince1970: unixUtc))
        })
        
        let today = Date()
        let nextFiveDays = Dictionary(grouping: forecastItems, by: {
            $0.dateTime.getTimeHorizon(from: today)
        })
        
        return WeatherForecast(nextFiveDays: nextFiveDays)
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

extension Date {
    private func matchWith(_ date: Date, offset: Int) -> Bool {
        let calendar = Calendar.current
        let offsetted = Date(timeInterval: TimeInterval(offset * 24 * 3600), since: date)
        
        return (calendar.component(.day, from: offsetted) == calendar.component(.day, from: self) && calendar.component(.month, from: offsetted) == calendar.component(.month, from: self) && calendar.component(.year, from: offsetted) == calendar.component(.year, from: self))
    }
    
    func getTimeHorizon(from date: Date) -> TimeHorizon {
        if (matchWith(date, offset: 0)) {
            return .today
        }
        if (matchWith(date, offset: 1)) {
            return .tomorrow
        }
        if (matchWith(date, offset: 2)) {
            return .twoDays
        }
        if (matchWith(date, offset: 3)) {
            return .threeDdays
        }
        if (matchWith(date, offset: 4)) {
            return .fourDays
        }
        if (matchWith(date, offset: 5)) {
            return .fiveDays
        }
        
        return .other
    }
}
