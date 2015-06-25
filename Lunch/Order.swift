//
//  Order.swift
//  Lunch
//
//  Created by Martina Oefelein on 14.06.15.
//  Copyright (c) 2015 Martina Oefelein. All rights reserved.
//

import Foundation

class Order {
    var current = [false, false, false, false, false]
    var next = [false, false, false, false, false]
    var alreadyOrdered = false
    let monday: NSDate
    
    init(today: NSDate) {
        self.monday = Order.mondayBeforeOrAt(today)
    }
    
    init(today: NSDate, withJsonObject json: NSDictionary) {
        self.monday = Order.mondayBeforeOrAt(today)
        if let thisWeek = json[jsonKey(0)] as? NSDictionary {
            current = thisWeek[Order.ordersJsonKey] as! [Bool]
        }
        if let nextWeek = json[jsonKey(1)] as? NSDictionary {
            alreadyOrdered = nextWeek[Order.finalJsonKey] as! Bool
            next = nextWeek[Order.ordersJsonKey] as! [Bool]
        }
    }
    
    func asJsonObject() -> NSDictionary {
        return [
            jsonKey(0): [
                Order.finalJsonKey: true,
                Order.ordersJsonKey: current
            ],
            jsonKey(1): [
                Order.finalJsonKey: alreadyOrdered,
                Order.ordersJsonKey: next
            ]
        ]
    }
    
    func valueForWeek(week: Int, day: Int) -> Bool {
        switch week {
        case 0:
            return current[day]
        case 1:
            return next[day]
        default:
            return false
        }
    }
    
    func weekLabel(week: Int) -> String {
        return formatWeek(week, withFormat: "'KW' w")
    }
    
    func dayLabel(#week: Int, day: Int) -> String {
        return formatWeek(week, day: day, withFormat: "EEEE, d.M.")
    }
    
    func orderedDays() -> String {
        var days: [String] = []
        for i in 0...4 {
            if next[i] {
                days.append(formatWeek(1, day: i, withFormat: "EEEE"))
            }
        }
        switch days.count {
        case 0:
            return "nichts"
        case 5:
            return "jeden Tag"
        default:
            return ", ".join(days)
        }
    }
    
    // Constants
    private static let oneDay = 24 * 60 * 60.0
    private static let oneWeek = 7 * oneDay
    private static let finalJsonKey = "final"
    private static let ordersJsonKey = "orders"
    private static let locale = NSLocale(localeIdentifier: "de")
    
    // Helper functions
    private func jsonKey(week: Int) -> String{
        return formatWeek(week, withFormat: "YYYY-ww")
    }
    
    static private func mondayBeforeOrAt(date: NSDate) -> NSDate {
        let dayNo = Order.formatDate(date, withFormat: "e").toInt()!
        return date.dateByAddingTimeInterval(-Order.oneDay * Double(dayNo - 1))
    }
    
    func formatWeek(week: Int, day: Int=0, withFormat: String) -> String {
        let date = monday.dateByAddingTimeInterval(Double(week) * Order.oneWeek + Double(day) * Order.oneDay)
        return Order.formatDate(date, withFormat: withFormat)
    }
    
    static private func formatDate(date: NSDate, withFormat: String) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = withFormat
        formatter.locale = Order.locale
        return formatter.stringFromDate(date)
    }
    
}