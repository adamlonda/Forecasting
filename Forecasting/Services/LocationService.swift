//
//  LocationService.swift
//  Forecasting
//
//  Created by Adam Londa on 09/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import CoreLocation
import RxCoreLocation
import RxSwift

class LocationService: LocationProtocol {
    private let manager: CLLocationManager
    
    init() {
        self.manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    var locationFeed: Observable<GpsCoords> {
        return manager.rx.location
            .map({ clLocation in
                return GpsCoords(
                    latitude: Double(clLocation?.coordinate.latitude ?? 0),
                    longitude: Double(clLocation?.coordinate.longitude ?? 0))
            })
            .distinctUntilChanged()
    }
}
