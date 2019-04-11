//
//  GpsCoords.swift
//  Forecasting
//
//  Created by Adam Londa on 09/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

struct GpsCoords : Equatable {
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

func == (lhs: GpsCoords, rhs: GpsCoords) -> Bool {
    return lhs.latitude == rhs.latitude
        && lhs.longitude == rhs.longitude
}
