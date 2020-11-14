//
//  CleanarchTests.swift
//  CleanarchTests
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import XCTest
@testable import Cleanarch

protocol HTTPClient {
    func get(from url: URL)
}

class DefaultPostService {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func fetchPosts() {
        client.get(from: url)
    }
    
}


class CleanarchTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        let _ = DefaultPostService(url: url, client: client)
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_fetchPosts_requestDataFromURL() {
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        let sut = DefaultPostService(url: url, client: client)
        
        sut.fetchPosts()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] = []
        
        func get(from url: URL) {
            requestedURLs.append(url)
        }
    }

}
