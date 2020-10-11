//
//  UserServiceImplMockTests.swift
//  CleanarchCoreTests
//
//  Created by Arifin Firdaus on 11/10/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import XCTest
@testable import CleanarchCore

class UserServiceImplMockTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
//    func test_fetchUsers_givenInvalidURL_shouldReturnInvalidURL() {
//        // given
//        let config: NetworkConfigurable = MockNetworkConfigurableImpl(
//            baseURL: URL(string: "an-invalid-url"),
//            headers: [:],
//            queryParameters: [:]
//        )
//        let sut: UserService = UserServiceImpl(config: config)
//
//        // when
//        sut.fetchUsers { result in
//            break
//        }
//
//        // then
//        XCTAssertEqual(config.baseURL, <#T##expression2: Equatable##Equatable#>)
//
//    }

}
