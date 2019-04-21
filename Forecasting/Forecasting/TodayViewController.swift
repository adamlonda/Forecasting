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
    
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var precipitationLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    
    private let notAvailableLabel = "N/A"
    
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
    
    private func setDefaultDisplay() {
        self.locationLabel.text = "Location not loaded"
        self.weatherLabel.text = "Weather not available"
        
        self.humidityLabel.text = notAvailableLabel
        self.precipitationLabel.text = notAvailableLabel
        self.pressureLabel.text = notAvailableLabel
        
        self.windSpeedLabel.text = notAvailableLabel
        self.windDirectionLabel.text = notAvailableLabel
    }
    
    private func display(_ currentWeather: CurrentWeather) {
        guard let weatherImage = UIImage(named: currentWeather.icon) else {
            fatalError("Weather code API error")
        }
        
        self.locationLabel.text = currentWeather.locationName
        self.weatherLabel.text = "\(Int(round(currentWeather.temperatureKelvin - 273.15)))°C | \(currentWeather.description)"
        self.weatherImageView.image = weatherImage
        
        self.humidityLabel.text = "\(currentWeather.humidity)%"
        self.precipitationLabel.text = currentWeather.precipitation != nil
            ? "\(currentWeather.precipitation!) mm"
            : self.notAvailableLabel
        self.pressureLabel.text = "\(currentWeather.pressure) hPa"
        
        self.windSpeedLabel.text = "\(Int(round(currentWeather.windSpeed * 3.6))) km/h"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultDisplay()
        
        _ = locationService?.locationFeed.flatMap({
            self.getCurrentWeather(latitude: $0.latitude, longitude: $0.longitude)
        })
        .subscribe(
            onNext: { currentWeather in
                self.display(currentWeather)
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
