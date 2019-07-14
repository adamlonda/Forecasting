//
//  CurrentWeatherViewController.swift
//  Forecasting
//
//  Created by Adam Londa on 05/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import RxSwift
import UIKit

//TODO: Weak-selves, fatalErros removal
class CurrentWeatherViewController: UIViewController {
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
    var weatherService: CurrentWeatherProtocol?
    
    private var locationChanges: Disposable?
    private var locationErrors: Disposable?
    
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
        self.weatherLabel.text = "\(celsiusLabelFrom(kelvin: currentWeather.temperatureKelvin)) | \(currentWeather.description)"
        self.weatherImageView.image = weatherImage
        
        self.humidityLabel.text = "\(currentWeather.humidity)%"
        self.precipitationLabel.text = currentWeather.mmRainVolume != nil
            ? "\(currentWeather.mmRainVolume!) mm"
            : self.notAvailableLabel
        self.pressureLabel.text = "\(currentWeather.pressure) hPa"
        
        self.windSpeedLabel.text = "\(Int(round(currentWeather.windSpeed * 3.6))) km/h"
        self.windDirectionLabel.text = "\(currentWeather.windDegrees.getWindDirection())".uppercased()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultDisplay()
        
        locationChanges = locationService?.locationFeed.flatMap({
            self.getCurrentWeather(latitude: $0.latitude, longitude: $0.longitude)
        }).subscribe(
            onNext: { currentWeather in
                self.display(currentWeather)
        },
            onError: { _ in
                self.presentNetworkError()
        })
        
        locationErrors = locationService?.errorFeed.subscribe(onNext: { _ in
            self.presentGeolocationError()
        })
    }
    
    deinit {
        locationChanges?.dispose()
        locationErrors?.dispose()
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
        let degrees = self % 360
        
        // MARK: North
        if 348 < degrees || degrees <= 11 {
            return .n
        }
        if 11 < degrees && degrees <= 33 {
            return .nne
        }
        if 33 < degrees && degrees <= 56 {
            return .ne
        }
        if 56 < degrees && degrees <= 78 {
            return .ene
        }
        
        // MARK: East
        if 78 < degrees && degrees <= 101 {
            return .e
        }
        if 101 < degrees && degrees <= 123 {
            return .ese
        }
        if 123 < degrees && degrees <= 146 {
            return .se
        }
        if 146 < degrees && degrees <= 168 {
            return .sse
        }
        
        // MARK: South
        if 168 < degrees && degrees <= 191 {
            return .s
        }
        if 191 < degrees && degrees <= 213 {
            return .ssw
        }
        if 213 < degrees && degrees <= 236 {
            return .sw
        }
        if 236 < degrees && degrees <= 258 {
            return .wsw
        }
        
        // MARK: West
        if 258 < degrees && degrees <= 281 {
            return .w
        }
        if 281 < degrees && degrees <= 303 {
            return .wnw
        }
        if 303 < degrees && degrees <= 326 {
            return .nw
        }
        if 326 < degrees && degrees <= 348 {
            return .nnw
        }
        
        fatalError("Should not happen")
    }
}
