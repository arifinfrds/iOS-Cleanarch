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
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_fetchPosts_requestDataFromURL() {
        let url = URL(string: "https://any-url.com")!
        let (sut, client) = makeSUT()
        
        sut.fetchPosts()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_fetchPosts_requestDataFromURLTwice() {
        let url = URL(string: "https://any-url.com")!
        let (sut, client) = makeSUT()
        
        sut.fetchPosts()
        sut.fetchPosts()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_fetchPosts_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        sut.fetchPosts()
        let expectedError = NSError(domain: "some error", code: 1, userInfo: nil)
        client.complete(with: expectedError)
        
        XCTAssertEqual(client.messages[0].error as NSError, expectedError)
    }
    
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://any-url.com")!) -> (sut: DefaultPostService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = DefaultPostService(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] = []
        var errros: [Error] = []
        
        struct Message {
            var requestedURL: URL
            var error: Error
        }
        
        var messages: [Message] = []
        
        func get(from url: URL) {
            requestedURLs.append(url)
        }
        
        
        // MARK: - Stubbing
        
        func complete(with error: Error) {
            let url = requestedURLs[0]
            let message = Message(requestedURL: url, error: error)
            messages.append(message)
        }
    }

}
