//
//  DefaultCommentsServiceTests.swift
//  CleanarchTests
//
//  Created by Arifin Firdaus on 14/11/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import XCTest
@testable import Cleanarch

class DefaultCommentsService {
    private let session: URLSession
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
        case serverError
    }
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchComments(completion: @escaping (Result<[Comment], Error>) -> Void) {
        let url = URL(string: "https://invalid-url.com")!
        session.dataTask(with: url) { (data, response, error) in
            if let error = error as NSError? {
                if error.domain == NSURLErrorDomain {
                    if error.code == NSURLErrorNotConnectedToInternet {
                        completion(.failure(.connectivity))
                        return
                    }
                    if error.code == NSURLErrorCannotParseResponse {
                        completion(.failure(.invalidData))
                        return
                    }
                    if error.code == NSURLErrorBadServerResponse {
                        completion(.failure(.serverError))
                        return
                    }
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 400 {
                        completion(.failure(.invalidData))
                    }
                    if httpResponse.statusCode == 500 {
                        completion(.failure(.serverError))
                    }
                }
                fatalError("Unhandled case yet")
            }
            fatalError("Unahndled case yet.")
        }.resume()
    }
}

class URLProtocolStub: URLProtocol {
    private static var error: Error?
    private static var data: Data?
    
    static func stub(with error: Error) {
        self.error = error
    }
    
    static func stub(with data: Data) {
        self.data = data
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = URLProtocolStub.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        if let data = URLProtocolStub.data {
            self.client?.urlProtocol(self, didLoad: data)
        }
    }
    
    override func stopLoading() { }
}


class DefaultCommentsServiceTests: XCTestCase {
    
    func test_fetchComments_deliversNoConnectivityError() {
        let sut = makeSUT()
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        URLProtocolStub.stub(with: error)
        
        let exp = expectation(description: "wait for request")
        var capturedErrors: [DefaultCommentsService.Error] = []
        sut.fetchComments { result in
            switch result {
            case .failure(let error):
                capturedErrors.append(error)
            default:
                XCTFail("Expected error, but got success instead.")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_fetchComments_deliversInvalidDataError() {
        let sut = makeSUT()
        URLProtocolStub.stub(with: NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotParseResponse))
        
        let exp = expectation(description: "wait for request")
        var capturedErrors: [DefaultCommentsService.Error] = []
        sut.fetchComments { result in
            switch result {
            case .failure(let error):
                capturedErrors.append(error)
            default:
                XCTFail("Expected error, but got success instead.")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(capturedErrors, [.invalidData])
    }
    
    func test_fetchComments_deliversServerError() {
        let sut = makeSUT()
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse)
        URLProtocolStub.stub(with: error)
        
        let exp = expectation(description: "wait for request")
        var capturedErrors: [DefaultCommentsService.Error] = []
        sut.fetchComments { result in
            switch result {
            case .failure(let error):
                capturedErrors.append(error)
            default:
                XCTFail("Expected error, but got success instead.")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(capturedErrors, [.serverError])
    }
    
    func test_fetchComments_deliversInvalidParsingData() {
        let sut = makeSUT()
        let invalidJSONData = "an-invalid-json".data(using: .utf8)!
        URLProtocolStub.stub(with: invalidJSONData)
        
        let exp = expectation(description: "wait for request")
        var capturedErrors: [DefaultCommentsService.Error] = []
        sut.fetchComments { result in
            switch result {
            case .failure(let error):
                capturedErrors.append(error)
            default:
                XCTFail("Expected error, but got success instead.")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(capturedErrors, [.invalidData])
    }
    
    // FIXME: - Not passing for empty json body, e.g.: "{}"
    
    
    
    // MARK: - Helpers
    
    func makeSUT() -> DefaultCommentsService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = DefaultCommentsService(session: session)
        return sut
    }

}
