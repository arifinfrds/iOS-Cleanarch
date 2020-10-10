//
//  CleanarchTests.swift
//  CleanarchTests
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import XCTest
@testable import Cleanarch

class CleanarchTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
//    func testPostGivenValidIdShouldReturnPost() {
//        let service: PostService = PostServiceImpl()
//        let repository: PostRepository = PostRepositoryImpl(postService: service)
//        let useCase: ViewPostUseCase = ShowPostUseCaseImpl(postRepository: repository)
//        let sut = DefaultPostDetailViewModel(useCase: useCase)
//
//        let id = 1
//        sut.loadPost(id: id)
//
//        let expectation = self.expectation(description: "fetch post")
//        waitForExpectations(timeout: 5) { error in
//            expectation.fulfill()
//        }
//        guard let receivedId = sut.post.value.id else { return }
//        XCTAssertEqual(receivedId, id)
//    }

}
