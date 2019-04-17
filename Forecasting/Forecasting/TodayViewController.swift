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
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var weatherImageView: UIImageView!
    
    var locationService: LocationProtocol?
    var weatherService: WeatherProtocol?
    
    private func presentError(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
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
        self.locationLabel.text = "Location not loaded"
        self.weatherLabel.text = "Weather not available"
        
        _ = locationService?.locationFeed.flatMap({
            self.getCurrentWeather(latitude: $0.latitude, longitude: $0.longitude)
        })
        .subscribe(
            onNext: { currentWeather in
                self.locationLabel.text = currentWeather.locationName
                self.weatherLabel.text = "\(Int(round(currentWeather.temperatureKelvin - 273.15)))°C | \(currentWeather.description)"
                self.weatherImageView.image = UIImage(named: currentWeather.icon)
        },
            onError: { _ in
                self.presentError(
                    title: "Network Error",
                    message: "An error occured while getting current weather. Please check your internet connection and try again later.")
        })
        
        _ = locationService?.errorFeed.subscribe(onNext: { _ in
            self.presentError(
                title: "Geolocation Error",
                message: "An error occured while getting your location. Please enable geolocation in your device settings for the Forecasting app, and try again.")
        })
    }
}
