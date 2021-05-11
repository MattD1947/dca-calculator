//
//  ios_dca_calculatorTests.swift
//  ios-dca-calculatorTests
//
//  Created by Changrui Li on 5/8/21.
//

import XCTest
@testable import ios_dca_calculator

class ios_dca_calculatorTests: XCTestCase {

    var sut: DCAService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DCAService()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

}
