//
//  TodayViewController.swift
//  Forecasting
//
//  Created by Adam Londa on 05/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import RxSwift
import UIKit

class TodayViewController: UIViewController {
    var locationService: LocationProtocol?
    var weatherService: WeatherProtocol?
    
    private func getCurrentWeather(latitude: Double, longitude: Double) -> Observable<CurrentWeather> {
        guard self.weatherService != nil else {
            fatalError("Should not happen.")
        }
        
        return self.weatherService!.getCurrentWeather(
            latitude: latitude,
            longitude: longitude)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = locationService?.locationFeed.flatMap({
            self.getCurrentWeather(latitude: $0.latitude, longitude: $0.longitude)
        })
        .subscribe(onNext: { currentWeather in
            print("Location name: \(currentWeather.locationName)")
        })
        
        _ = locationService?.errorFeed.subscribe(onNext: { _ in
            let alert = UIAlertController(
                title: "Geolocation Error",
                message: "An error occured while getting your location. Please enable geolocation in your device settings for the Forecasting app, and try again.",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
        })
    }
}
