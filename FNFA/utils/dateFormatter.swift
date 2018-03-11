//
//  dateFormatter.swift
//  FNFA
//
//  Created by MINERVINI Robin on 13/02/2018.
//  Copyright © 2018 MINERVINI Robin. All rights reserved.
//

import Foundation

extension Date {
    // Format : Mercredi
    var nameDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    
    // Format : Mercredi 10
    var nameNumberDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEEE d"
        return formatter.string(from: self)
    }
    
    // Format : 10 mars
    var numberMonthDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: self)
    }

    // Format : Mercredi 10 mars
    var nameNumberMonthDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEEE d MMMM"
        return formatter.string(from: self)
    }
    
    // Format : 12:30
    var hourDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    // Format : 2018-07-20 07:19:57 +0000
    var iosDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "AAAA-MM-EE"
        return formatter.string(from: self)
    }
}
