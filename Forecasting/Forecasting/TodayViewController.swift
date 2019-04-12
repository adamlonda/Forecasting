//
//  TodayViewController.swift
//  Forecasting
//
//  Created by Adam Londa on 05/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    var locationService: LocationProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = locationService?.locationFeed.subscribe(onNext: { coord in
            print("Latitude: \(coord.latitude) Longitude: \(coord.longitude)")
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
