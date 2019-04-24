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
    
    internal func check(_ response: DataResponse<Any>) throws -> [String: Any] {
        guard response.result.error == nil else {
            throw response.result.error!
        }

        guard let data = response.result.value as! [String: Any]? else {
            throw NetworkingError.emptyResponse
        }

        //FIXME: Different response code for each service
        guard let responseCode = data["cod"] as! Int? else {
            throw NetworkingError.noResponseCode
        }

        switch responseCode {
        case 200:
            return data
        case 401:
            throw NetworkingError.invalidApiKey
        default:
            throw NetworkingError.apiError
        }
    }
}
