//
//  DefaultPostServiceTests.swift
//  CleanarchTests
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import XCTest
@testable import Cleanarch

fileprivate protocol HTTPClient {
    func get(from url: URL)
}

fileprivate class DefaultPostService {
    private let url: URL
    private let client: HTTPClient
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func fetchPosts(completion: (Result<Post, Error>) -> Void) {
        client.get(from: url)
        
        completion(.failure(.connectivity))
    }
    
}


class DefaultPostServiceTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_fetchPosts_requestDataFromURL() {
        let url = URL(string: "https://any-url.com")!
        let (sut, client) = makeSUT()
        
        sut.fetchPosts { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_fetchPosts_requestDataFromURLTwice() {
        let url = URL(string: "https://any-url.com")!
        let (sut, client) = makeSUT()
        
        sut.fetchPosts { _ in }
        sut.fetchPosts { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_fetchPosts_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedError: DefaultPostService.Error?
        let exp = expectation(description: "wait for completion")
        sut.fetchPosts { result in
            switch result {
            case .failure(let error):
                capturedError = error
            default:
                XCTFail("Expected failure with error, but got success instead.")
            }
            exp.fulfill()
        }
        let expectedError = NSError(domain: "some error", code: 1, userInfo: nil)
        client.complete(with: expectedError)
        
        wait(for: [exp], timeout: 1.0)
        
        // XCTAssertEqual(client.messages[0].error as NSError, capturedError)
        XCTAssertEqual(capturedError, .connectivity)
    }
    
    // FIXME: - I dont know how to stub error here.
    
    func test_fetchPosts_deliversErrorOnNon200HTTPResposne() {
        let (sut, client) = makeSUT()
        
        // client.complete(with: T##Error)
        var capturedError: DefaultPostService.Error?
        sut.fetchPosts { result in
            switch result {
            case .failure(let error):
                capturedError = error
            default:
                XCTFail("Expected failure with error, but got success instead.")
            }
        }
        
        XCTAssertEqual(capturedError, .connectivity)
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
