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
    
    var weatherForecast: WeatherForecast?
    
    private func getWeatherForecast(latitude: Double, longitude: Double) -> Observable<WeatherForecast> {
        guard self.weatherService != nil else {
            fatalError("Should not happen.")
        }
        
        return self.weatherService!.getWeatherForecast(latitude: latitude, longitude: longitude)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = locationService?.locationFeed.flatMap({
            return self.getWeatherForecast(latitude: $0.latitude, longitude: $0.longitude)
        }).subscribe(
            onNext: { forecast in
                self.weatherForecast = forecast
//                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        },
            onError: { error in
                self.presentNetworkError()
        })
        
        _ = locationService?.errorFeed.subscribe(onNext: { _ in
            self.presentGeolocationError()
        })
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return weatherForecast?.nextFiveDays.count ?? 0
//    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let timeHorizon = TimeHorizon(rawValue: section) else {
//            fatalError("Invalid header")
//        }
//
//        return weatherForecast?.nextFiveDays[timeHorizon]?.count ?? 0
//    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        guard let timeHorizon = TimeHorizon(rawValue: section) else {
//            fatalError("Invalid header")
//        }
//
//        return timeHorizon.getLabel()
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        fatalError("Not implemented")
//    }
}
