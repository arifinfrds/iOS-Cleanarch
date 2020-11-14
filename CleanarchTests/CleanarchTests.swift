//
//  CleanarchTests.swift
//  CleanarchTests
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import XCTest
@testable import Cleanarch

protocol HTTPClient { }

class DefaultPostService {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
}


class CleanarchTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        let _ = DefaultPostService(client: client)
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] = []
    }

}
