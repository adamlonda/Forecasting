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
