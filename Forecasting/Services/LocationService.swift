//
//  LocationService.swift
//  Forecasting
//
//  Created by Adam Londa on 09/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import RxSwift

class LocationService: LocationProtocol {
    var locationFeed: Observable<GpsCoords> {
        fatalError("Not implemented")
    }
}
