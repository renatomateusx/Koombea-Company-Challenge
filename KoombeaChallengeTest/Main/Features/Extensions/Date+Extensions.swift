//
//  Date+Extensions.swift
//  KoombeaChallengeTest
//
//  Created by Renato Mateus De Moura Santos on 26/09/21.
//

import Foundation

extension Date {
    func getDate(dateString: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "E MMM d yyyy HH:mm:ss 'GMT'ZZZZ"
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.timeZone = TimeZone(abbreviation: "GMT")

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd\(daySuffix())"

        let date: Date? = dateFormatterGet.date(from: dateString)
        let formatedDate = dateFormatterPrint.string(from: date!)
        
        return formatedDate
    }
    
    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
}
