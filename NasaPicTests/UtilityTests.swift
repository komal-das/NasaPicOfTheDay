//
//  UtilityTests.swift
//  NasaPicTests
//
//  Created by Das,KomalNutan on 22/11/22.
//

import XCTest

class UtilityTests: XCTestCase {

    func test_SplitDateString() throws {
        var dateTupples = Utility.splitDateString(strDate: "2020-01-19")
        XCTAssertEqual(dateTupples.day, "19", "splitDateString is returning wrong day value")
        XCTAssertEqual(dateTupples.year, "2020", "splitDateString is returning wrong year value")
        XCTAssertEqual(dateTupples.month, "Jan", "splitDateString is returning wrong month value")
        
        dateTupples = Utility.splitDateString(strDate: "1989-12-01")
        XCTAssertEqual(dateTupples.day, "01", "splitDateString is returning wrong day value")
        XCTAssertEqual(dateTupples.year, "1989", "splitDateString is returning wrong year value")
        XCTAssertEqual(dateTupples.month, "Dec", "splitDateString is returning wrong month value")
    }

}
