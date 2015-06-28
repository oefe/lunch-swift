//
//  OrderIO.swift
//  Lunch
//
//  Created by Martina Oefelein on 27.06.15.
//  Copyright (c) 2015 Martina Oefelein. All rights reserved.
//

import Foundation

func saveOrder(order: Order) {
    let json = order.asJsonObject()
    var error: NSErrorPointer = nil
    if let data = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted, error: error) {
        data.writeToURL(dataFileUrl(), atomically: true)
    }
}

func loadOrder() -> Order? {
    var error: NSErrorPointer = nil
    if let data = NSData(contentsOfURL:dataFileUrl()) {
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: error) as? NSDictionary {
            return Order(today: NSDate(), withJsonObject: json)
        }
    }
    return nil
}

private func dataFileUrl() -> NSURL {
    let fm = NSFileManager()
    var error: NSErrorPointer = nil
    let url = fm.URLForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false, error: error)
    return url!
}

