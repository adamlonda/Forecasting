//
//  UIViewControllerExtensions.swift
//  Forecasting
//
//  Created by Adam Londa on 25/04/2019.
//  Copyright © 2019 Adam Londa. All rights reserved.
//

import UIKit

extension UIViewController {
    private func presentError(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentGeolocationError() {
        self.presentError(
            title: "Geolocation Error",
            message: "An error occured while getting your location. Please enable geolocation in your device settings for the Forecasting app, and try again.")
    }
    
    func presentNetworkError() {
        self.presentError(
            title: "Network Error",
            message: "An error occured while getting current weather. Please check your internet connection and try again later.")
    }
    
    func celsiusLabelFrom(kelvin: Float) -> String {
        return "\(Int(round(kelvin - 273.15)))°C"
    }
}
