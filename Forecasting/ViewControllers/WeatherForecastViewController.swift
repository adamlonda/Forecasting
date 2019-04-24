//
//  WeatherForecastViewController.swift
//  Forecasting
//
//  Created by Adam Londa on 23/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import UIKit

class WeatherForecastViewController: UIViewController {
    var weatherService: WeatherForecastProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = weatherService?.getWeatherForecast(latitude: 0, longitude: 0).subscribe(
            onNext: { forecast in
                print("Got the forecast")
        },
            onError: { error in
                print("Forecast error")
        })
    }
}
