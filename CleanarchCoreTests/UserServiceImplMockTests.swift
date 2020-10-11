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
    
    func test_UserServiceImplMock_fetchUsers_givenNoConnectionError_shouldReturnNoConnectionError() {
        // let given
        let sut: UserService = UserServiceImplMock(expectedCase: .fail(error: .noInternetConnection))
        var capturedErrors: [LoadUsersError] = []
        let expectation = self.expectation(description: "should return no internect connection error.")
        
        // when
        sut.fetchUsers { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                capturedErrors.append(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        
        // then
        XCTAssertEqual(capturedErrors, [.noInternetConnection])
    }
    
    func test_UserServiceImplMock_fetchUsers_givenServerError_shouldReturnServerError() {
        // let given
        let sut: UserService = UserServiceImplMock(expectedCase: .fail(error: .serverError))
        var capturedErrors: [LoadUsersError] = []
        let expectation = self.expectation(description: "should return no internect connection error.")
        
        // when
        sut.fetchUsers { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                capturedErrors.append(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        
        // then
        XCTAssertEqual(capturedErrors, [.serverError])
    }
    
    func test_UserServiceImplMock_fetchUsers_givenInvalidTokenError_shouldReturnInvalidTokenError() {
        // let given
        let sut: UserService = UserServiceImplMock(expectedCase: .fail(error: .invalidToken))
        var capturedErrors: [LoadUsersError] = []
        let expectation = self.expectation(description: "should return no internect connection error.")
        
        // when
        sut.fetchUsers { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                capturedErrors.append(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        
        // then
        XCTAssertEqual(capturedErrors, [.invalidToken])
    }
    
    func test_UserServiceImplMock_fetchUsers_givenInvalidURL_shouldReturnInvalidURLError() {
        // let given
        let sut: UserService = UserServiceImplMock(expectedCase: .fail(error: .invalidURL))
        var capturedErrors: [LoadUsersError] = []
        let expectation = self.expectation(description: "should return no internect connection error.")
        
        // when
        sut.fetchUsers { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                capturedErrors.append(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        
        // then
        XCTAssertEqual(capturedErrors, [.invalidURL])
    }
    
    func test_UserServiceImplMock_fetchUsers_givenSuccessPath_shouldReturnProperArrays() {
        // let given
        let sut: UserService = UserServiceImplMock(expectedCase: .success)
        var capturedErrors: [LoadUsersError] = []
        var capturedUsers: [User] = []
        let expectedUsers = [User(id: 1, name: "Arifin Firdaus", username: "arifinfrds", email: nil)]
        let expectation = self.expectation(description: "should return array of users.")
        
        // when
        sut.fetchUsers { result in
            switch result {
            case .success(let users):
                capturedUsers = users
            case .failure(let error):
                capturedErrors.append(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        
        // then
        XCTAssertEqual(capturedErrors, [])
        XCTAssertEqual(capturedUsers, expectedUsers)
    }
}
