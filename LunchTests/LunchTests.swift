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
        let order = Order()
        
        XCTAssertEqual(order.alreadyOrdered, false, "not ordered yet")
        XCTAssertEqual(order.current, [false, false, false, false, false], "nothing ordered this week")
        XCTAssertEqual(order.next, [false, false, false, false, false], "nothing ordered next week")
     }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
