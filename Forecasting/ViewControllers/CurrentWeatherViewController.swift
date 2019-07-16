//
//  CurrentWeatherViewController.swift
//  Forecasting
//
//  Created by Adam Londa on 05/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import RxSwift
import UIKit

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
    
    private let disposeBag = DisposeBag()
    
    private func getCurrentWeatherWithImage(latitude: Double, longitude: Double) -> Observable<(CurrentWeather, UIImage)> {
        if self.weatherService == nil {
            fatalError("Dependency injection error")
        }
        
        return self.weatherService!.getCurrentWeather(latitude: latitude, longitude: longitude)
            .map({ currentWeather in
                guard let weatherImage = UIImage(named: currentWeather.icon) else {
                    throw CommonError.apiError
                }
                return (currentWeather, weatherImage)
            })
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
    
    private func display(_ currentWeather: CurrentWeather, with image: UIImage) {
        self.locationLabel.text = currentWeather.locationName
        self.weatherLabel.text = "\(celsiusLabelFrom(kelvin: currentWeather.temperatureKelvin)) | \(currentWeather.description)"
        self.weatherImageView.image = image
        
        self.humidityLabel.text = "\(currentWeather.humidity)%"
        self.pressureLabel.text = "\(currentWeather.pressure) hPa"
        self.precipitationLabel.text = currentWeather.mmRainVolume != nil
            ? "\(currentWeather.mmRainVolume!) mm"
            : self.notAvailableLabel
        
        self.windSpeedLabel.text = "\(Int(round(currentWeather.windSpeed * 3.6))) km/h"
        self.windDirectionLabel.text = "\(currentWeather.windDegrees.getWindDirection())".uppercased()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultDisplay()
        
        locationService?.locationFeed.flatMap({ [weak self] gps -> Observable<(CurrentWeather, UIImage)> in
            if (self == nil) {
                throw CommonError.runtimeError
            }
            return self!.getCurrentWeatherWithImage(latitude: gps.latitude, longitude: gps.longitude)
        }).subscribe(
            onNext: { [weak self] weatherWithImage in
                let weather = weatherWithImage.0
                let image = weatherWithImage.1
                self?.display(weather, with: image)
        },
            onError: { [weak self] _ in
                self?.presentError()
        }).disposed(by: disposeBag)
        
        locationService?.errorFeed.subscribe(onNext: { [weak self] _ in
            self?.presentGeolocationError()
        }).disposed(by: disposeBag)
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
