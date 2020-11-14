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
        case invalidData
    }
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchComments(completion: @escaping (Result<[Comment], Error>) -> Void) {
        let url = URL(string: "https://invalid-url.com")!
        session.dataTask(with: url) { (_, _, _) in
            completion(.failure(.invalidData))
        }.resume()
    }
}

class URLProtocolStub: URLProtocol {
    private static var error: Error?
    
    static func stub(with error: Error) {
        self.error = error
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
    }
    
    override func stopLoading() { }
}


class DefaultCommentsServiceTests: XCTestCase {
    
    // testing error response
    func test_fetchComments_deliversInvalidDataError() {
        let sut = makeSUT()
        URLProtocolStub.stub(with: NSError(domain: NSURLErrorDomain, code: 1))
        
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
    
    func makeSUT() -> DefaultCommentsService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = DefaultCommentsService(session: session)
        return sut
    }

}
