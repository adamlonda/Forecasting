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
    func groupByTimeHorizon(_ ungroupped: UngrouppedForecast, from today: Date) -> [ForecastGroup] {
        let grouping = Dictionary(grouping: ungroupped.items, by: {
            $0.dateTime.getTimeHorizon(from: today)
        })
        
        return grouping.map({ (key, values) in
            return ForecastGroup(timeHorizon: key, items: values)
        })
    }
    
    func getWeatherForecast(latitude: Double, longitude: Double) -> Observable<[ForecastGroup]> {
        let url = "\(self.baseUrl)/forecast?lat=\(latitude)&lon=\(longitude)&APPID=\(self.apiKey)"
        return RxAlamofire.requestData(.get, url)
            .map({ [weak self] (response, data) in
                if (self == nil) {
                    //TODO: CommonErrors enum
                    fatalError("Runtime error")
                }
                
                if (self!.check(response)) {
                    let ungroupped = try JSONDecoder().decode(UngrouppedForecast.self, from: data)
                    return self!.groupByTimeHorizon(ungroupped, from: Date())
                }
                
                throw NetworkingError.apiError
            })
    }
}

extension Date {
    private func matchWith(_ date: Date, offset: Int) -> Bool {
        let calendar = Calendar.current
        let offsetted = Date(timeInterval: TimeInterval(offset * 24 * 3600), since: date)
        
        let isMatching = (calendar.component(.day, from: offsetted) == calendar.component(.day, from: self) &&
            calendar.component(.month, from: offsetted) == calendar.component(.month, from: self) &&
            calendar.component(.year, from: offsetted) == calendar.component(.year, from: self))
        
        return isMatching
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
