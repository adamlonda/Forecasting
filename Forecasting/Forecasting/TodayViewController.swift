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
        _ = locationService?.getCurrentLocation()
    }
}
