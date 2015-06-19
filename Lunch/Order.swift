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
    let today: NSDate
    
    init(today: NSDate) {
        self.today = today
    }
    
    init(today: NSDate, withJsonObject json: NSDictionary) {
        self.today = today
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
    
    // Constants
    private static let oneDay = 24 * 60 * 60.0
    private static let oneWeek = 7 * oneDay
    private static let finalJsonKey = "final"
    private static let ordersJsonKey = "orders"
    
    // Helper functions
    private func jsonKey(weeksForward: Double) -> String{
        let date = today.dateByAddingTimeInterval(weeksForward * Order.oneWeek)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-ww"
        return formatter.stringFromDate(date)
    }
}