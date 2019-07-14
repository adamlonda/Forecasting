//
//  WeatherForecastViewController.swift
//  Forecasting
//
//  Created by Adam Londa on 23/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import RxSwift
import UIKit

//TODO: Weak-selves, fatalErros removal
class WeatherForecastViewController: UITableViewController {
    var locationService: LocationProtocol?
    var weatherService: WeatherForecastProtocol?
    
    private var weatherForecast: [ForecastGroup]?
    
    private var locationChanges: Disposable?
    private var locationErrors: Disposable?
    
    private func getWeatherForecast(latitude: Double, longitude: Double) -> Observable<[ForecastGroup]> {
        if self.weatherService == nil {
            fatalError("Should not happen.")
        }
        return self.weatherService!.getWeatherForecast(latitude: latitude, longitude: longitude)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherForecast = [ForecastGroup]()
        
        locationChanges = locationService?.locationFeed.flatMap({
            return self.getWeatherForecast(latitude: $0.latitude, longitude: $0.longitude)
        }).subscribe(
            onNext: { forecast in
                self.weatherForecast = forecast
                self.tableView.reloadData()
        },
            onError: { error in
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = weatherForecast?.count else {
            return 0
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = weatherForecast?[section].items.count else {
            return 0
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let timeHorizon = TimeHorizon(rawValue: section) else {
            fatalError("Invalid header")
        }

        return timeHorizon.getLabel()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "forecastTableViewCell", for: indexPath) as? WeatherForecastTableViewCell else {
            fatalError("Table cell type mismatch")
        }
        
        guard let section = weatherForecast?[indexPath.section] else {
            return cell
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        cell.timeLabel.text = dateFormatter.string(from: section.items[indexPath.row].dateTime)
        cell.forecastImageView.image = UIImage(named: section.items[indexPath.row].icon)
        cell.descriptionLabel.text = section.items[indexPath.row].description
        cell.temperatureLabel.text = celsiusLabelFrom(kelvin: section.items[indexPath.row].temperatureKelvin)
        
        return cell
    }
}
