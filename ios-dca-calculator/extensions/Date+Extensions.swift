//
//  Date+Extensions.swift
//  ios-dca-calculator
//
//  Created by Changrui Li on 5/6/21.
//

import Foundation

extension Date {
    var MMYYFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
