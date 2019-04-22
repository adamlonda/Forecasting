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
        self.windDirectionLabel.text = "\((currentWeather.windDegrees % 360).getWindDirection())".uppercased()
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

// MARK: Degrees -> Enum type
extension Int {
    enum WindDirection {
        case n, nne, ne, ene
        case e, ese, se, sse
        case s, ssw, sw, wsw
        case w, wnw, nw, nnw
    }
    
    func getWindDirection() -> WindDirection {
        // MARK: North
        if 348 < self || self <= 11 {
            return WindDirection.n
        }
        if 11 < self && self <= 33 {
            return WindDirection.nne
        }
        if 33 < self && self <= 56 {
            return WindDirection.ne
        }
        if 56 < self && self <= 78 {
            return WindDirection.ene
        }
        
        // MARK: East
        if 78 < self && self <= 101 {
            return WindDirection.e
        }
        if 101 < self && self <= 123 {
            return WindDirection.ese
        }
        if 123 < self && self <= 146 {
            return WindDirection.se
        }
        if 146 < self && self <= 168 {
            return WindDirection.sse
        }
        
        // MARK: South
        if 168 < self && self <= 191 {
            return WindDirection.s
        }
        if 191 < self && self <= 213 {
            return WindDirection.ssw
        }
        if 213 < self && self <= 236 {
            return WindDirection.sw
        }
        if 236 < self && self <= 258 {
            return WindDirection.wsw
        }
        
        // MARK: West
        if 258 < self && self <= 281 {
            return WindDirection.w
        }
        if 281 < self && self <= 303 {
            return WindDirection.wnw
        }
        if 303 < self && self <= 326 {
            return WindDirection.nw
        }
        if 326 < self && self <= 348 {
            return WindDirection.nnw
        }
        
        fatalError("Should not happen")
    }
}
