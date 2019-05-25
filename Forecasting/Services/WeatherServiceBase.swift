//
//  WeatherServiceBase.swift
//  Forecasting
//
//  Created by Adam Londa on 24/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import Alamofire

enum NetworkingError: Error {
    case emptyResponse
    case noResponseCode
    case invalidApiKey
    case apiError
}

class WeatherServiceBase {
    internal let apiKey = "4b41e86332361042c6ee97624f64b591"
    internal let baseUrl = "https://api.openweathermap.org/data/2.5"
    
    internal func check(_ response: HTTPURLResponse) -> Bool {
        switch response.statusCode {
        case 200:
            return true
        default:
            return false
        }
    }
}
