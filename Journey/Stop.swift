//
//  Stop.swift
//  Journey
//
//  Created by Caleb Elson on 5/1/24.
//

import Foundation
import UIKit
import SwiftData
import CountryPicker

@Model
final class Stop {
    var fromDate: Date
    var toDate: Date
    var countryName: String
    var city: String
    var current: Bool
    
    init(fromDate: Date, toDate: Date, countryName: String, city: String, current: Bool) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.countryName = countryName
        self.city = city
        self.current = current
    }
    
    func getTimeLived() -> TimeInterval {
        return current ? Date().distance(to: fromDate) : toDate.distance(to: fromDate)
    }
}
