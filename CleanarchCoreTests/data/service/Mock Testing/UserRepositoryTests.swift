//
//  UserRepositoryTests.swift
//  CleanarchCoreTests
//
//  Created by Arifin Firdaus on 14/10/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import XCTest
@testable import CleanarchCore

class UserRepositoryTests: XCTestCase {

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
    
    func test_fetchUsers_givenInvalidBundleDependencyMockService_shouldReturnInvalidBundleError() {
        // given
        let bundle = Bundle(for: UserRepositoryImpl.self)
        let service: UserService = MockUserServiceImpl(bundle: bundle)
        let sut: UserRepository = UserRepositoryImpl(service: service)
        var capturedErrors: [LoadUsersError] = []
        
        // when
        sut.fetchUsers { result in
            switch result {
            case .success(_):
                XCTFail("expected error, but got user instead.")
            case .failure(let error):
                capturedErrors.append(error)
            }
        }
        
        // then
        XCTAssertEqual(capturedErrors, [.invalidBundleUrl])
    }
    
    func test_fetchUsers_givenValidMockService_shouldReturnUsers() {
        // given
        let bundle = Bundle(for: UserRepositoryTests.self)
        let service: UserService = MockUserServiceImpl(expectedCase: .success, bundle: bundle)
        let sut: UserRepository = UserRepositoryImpl(service: service)
        var capturedUsers: [User] = []
        
        // when
        sut.fetchUsers { result in
            switch result {
            case .success(let users):
                capturedUsers = users
            case .failure(let error):
                XCTFail("expected users, but got error instead. Reason: \(error.localizedDescription)")
            }
        }
        
        // then
        XCTAssertEqual(capturedUsers, [User(id: 1, name: "Leanne Graham", username: "Bret", email: "Sincere@april.biz")])
    }

}
