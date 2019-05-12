//
//  WeatherForecastViewController.swift
//  Forecasting
//
//  Created by Adam Londa on 23/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import RxSwift
import UIKit

class WeatherForecastViewController: UITableViewController {
    var locationService: LocationProtocol?
    var weatherService: WeatherForecastProtocol?
    
    var weatherForecast: [Forecast]?
    
    private func getWeatherForecast(latitude: Double, longitude: Double) -> Observable<[Forecast]> {
        guard self.weatherService != nil else {
            fatalError("Should not happen.")
        }
        
        return self.weatherService!.getWeatherForecast(latitude: latitude, longitude: longitude)
            .map({ items in
                let today = Date()
                let grouping = Dictionary(grouping: items, by: {
                    $0.dateTime.getTimeHorizon(from: today)
                })

                return grouping.map({ (key, values) in
                    return Forecast(timeHorizon: key, items: values)
                })
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherForecast = [Forecast]()
        
        _ = locationService?.locationFeed.flatMap({
            return self.getWeatherForecast(latitude: $0.latitude, longitude: $0.longitude)
        }).subscribe(
            onNext: { forecast in
                self.weatherForecast?.removeAll()
                self.weatherForecast?.append(contentsOf: forecast)
                self.tableView.reloadData()
        },
            onError: { error in
                self.presentNetworkError()
        })
        
        _ = locationService?.errorFeed.subscribe(onNext: { _ in
            self.presentGeolocationError()
        })
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

extension Date {
    private func matchWith(_ date: Date, offset: Int) -> Bool {
        let calendar = Calendar.current
        let offsetted = Date(timeInterval: TimeInterval(offset * 24 * 3600), since: date)
        
        return (calendar.component(.day, from: offsetted) == calendar.component(.day, from: self) && calendar.component(.month, from: offsetted) == calendar.component(.month, from: self) && calendar.component(.year, from: offsetted) == calendar.component(.year, from: self))
    }
    
    func getTimeHorizon(from date: Date) -> TimeHorizon {
        if (matchWith(date, offset: 0)) {
            return .today
        }
        if (matchWith(date, offset: 1)) {
            return .tomorrow
        }
        if (matchWith(date, offset: 2)) {
            return .twoDays
        }
        if (matchWith(date, offset: 3)) {
            return .threeDdays
        }
        if (matchWith(date, offset: 4)) {
            return .fourDays
        }
        if (matchWith(date, offset: 5)) {
            return .fiveDays
        }
        
        return .other
    }
}
