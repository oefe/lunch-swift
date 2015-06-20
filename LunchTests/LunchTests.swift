//
//  LunchTests.swift
//  LunchTests
//
//  Created by Martina Oefelein on 14.06.15.
//  Copyright (c) 2015 Martina Oefelein. All rights reserved.
//

import UIKit
import XCTest

class LunchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmpty() {
        let order = Order(today: date("17.06.2015"))
        
        XCTAssertEqual(order.alreadyOrdered, false, "not ordered yet")
        XCTAssertEqual(order.current, [false, false, false, false, false], "nothing ordered this week")
        XCTAssertEqual(order.next, [false, false, false, false, false], "nothing ordered next week")
    }
    
    func testSaveLoadSameDay() {
        let old = Order(today: date("24.06.2015"))
        old.alreadyOrdered = true
        old.current[1] = true
        old.next[2] = true
        let json = old.asJsonObject()
        
        let new = Order(today: date("24.06.2015"), withJsonObject: json)
        
        XCTAssertEqual(new.alreadyOrdered, true, "already ordered")
        XCTAssertEqual(new.current, [false, true, false, false, false], "Tuesday ordered this week")
        XCTAssertEqual(new.next, [false, false, true, false, false], "Wednesday ordered next week")
    }
    
    func testSaveLoadSameWeek() {
        let old = Order(today: date("24.06.2015"))
        old.alreadyOrdered = false
        old.current[3] = true
        old.next[4] = true
        let json = old.asJsonObject()
        
        let new = Order(today: date("25.06.2015"), withJsonObject: json)
        
        XCTAssertEqual(new.alreadyOrdered, false, "not already ordered")
        XCTAssertEqual(new.current, [false, false, false, true, false], "Thursday ordered this week")
        XCTAssertEqual(new.next, [false, false, false, false, true], "Friday ordered next week")
    }
    
    func testSaveLoadNextWeek() {
        let old = Order(today: date("24.06.2015"))
        old.alreadyOrdered = true
        old.current[1] = true
        old.next[0] = true
        let json = old.asJsonObject()
        
        let new = Order(today: date("29.06.2015"), withJsonObject: json)
        
        XCTAssertEqual(new.alreadyOrdered, false, "not already ordered")
        XCTAssertEqual(new.current, [true, false, false, false, false], "Monday ordered this week")
    }
    
    func testSaveLoadTwoWeeksLater() {
        let old = Order(today: date("24.06.2015"))
        old.alreadyOrdered = true
        old.current[1] = true
        old.next[2] = true
        let json = old.asJsonObject()
        
        let new = Order(today: date("06.07.2015"), withJsonObject: json)
        
        XCTAssertEqual(new.alreadyOrdered, false, "not ordered yet")
        XCTAssertEqual(new.current, [false, false, false, false, false], "nothing ordered this week")
        XCTAssertEqual(new.next, [false, false, false, false, false], "nothing ordered next week")
    }
    
    func testWeekLabel() {
        let order = Order(today: date("17.06.2015"))
        
        XCTAssertEqual(order.weekLabel(0), "KW 25", "this week")
        XCTAssertEqual(order.weekLabel(1), "KW 26", "next week")
    }
    
    func testWeekLabelOnNewYearsEve() {
        let order = Order(today: date("31.12.2015"))
        
        XCTAssertEqual(order.weekLabel(0), "KW 53", "this week")
        XCTAssertEqual(order.weekLabel(1), "KW 1", "next week")
    }
    
    func testDayLabel() {
        let order = Order(today: date("17.06.2015"))
        
        XCTAssertEqual(order.dayLabel(week: 0, day: 0), "Montag, 15.6.", "this Monday")
        XCTAssertEqual(order.dayLabel(week: 0, day: 4), "Freitag, 19.6.", "this Friday")
        XCTAssertEqual(order.dayLabel(week: 1, day: 0), "Montag, 22.6.", "next Monday")
        XCTAssertEqual(order.dayLabel(week: 1, day: 4), "Freitag, 26.6.", "next Friday")
    }
    
    func testDayLabelOnNewYearsEve() {
        let order = Order(today: date("31.12.2015"))
        
        XCTAssertEqual(order.dayLabel(week: 0, day: 0), "Montag, 28.12.", "this Monday")
        XCTAssertEqual(order.dayLabel(week: 0, day: 4), "Freitag, 1.1.", "this Friday")
        XCTAssertEqual(order.dayLabel(week: 1, day: 0), "Montag, 4.1.", "next Monday")
        XCTAssertEqual(order.dayLabel(week: 1, day: 4), "Freitag, 8.1.", "next Friday")
    }
    
    func testOrderedDaysNothing() {
        let order = Order(today: date("17.06.2015"))

        XCTAssertEqual(order.orderedDays(), "nichts", "special case wording")
    }
    
    func testOrderedDaysEveryDay() {
        let order = Order(today: date("17.06.2015"))
        order.next = [true, true, true, true, true]
        
        XCTAssertEqual(order.orderedDays(), "jeden Tag", "special case wording")
    }
    
    func testOrderedDaysSomeDays() {
        let order = Order(today: date("17.06.2015"))
        order.next = [true, false, false, true, true]
        
        XCTAssertEqual(order.orderedDays(), "Montag, Donnerstag, Freitag", "simple list of days")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func date(when: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "de")
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        return formatter.dateFromString(when)!
    }
}
