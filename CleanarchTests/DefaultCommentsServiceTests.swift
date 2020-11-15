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
    
    enum Error: Swift.Error, Equatable {
        case connectivity
        case invalidData
        case serverError
        case decodeFail(message: String)
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
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 400 {
                    completion(.failure(.invalidData))
                    return
                }
                if httpResponse.statusCode == 500 {
                    completion(.failure(.serverError))
                    return
                }
                if httpResponse.statusCode == 200 {
                    let completionResult = CommentsMapper.map(data!)
                    completion(completionResult)
                    return
                }
            }
            fatalError("Unahndled case yet.")
        }.resume()
    }
}



class URLProtocolStub: URLProtocol {
    private static var error: Error?
    private static var data: Data?
    private static var httpURLResponse: HTTPURLResponse?
    
    static func stub(with error: Error) {
        self.error = error
    }
    
    static func stub(with data: Data) {
        self.data = data
    }
    
    static func stub(httpURLResponse: HTTPURLResponse?, data: Data?) {
        self.httpURLResponse = httpURLResponse
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
        if let response = URLProtocolStub.httpURLResponse {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        self.client?.urlProtocolDidFinishLoading(self)
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
    
    func test_fetchComments_deliversEmptyItems() {
        let sut = makeSUT()
        let url = makeAnyURL()
        let response = makeHTTPURLResponse(url: url, statusCode: 200)
        let data = "[]".data(using: .utf8)!
        
        URLProtocolStub.stub(httpURLResponse: response, data: data)
        
        let exp = expectation(description: "wait for request")
        var capturedComments: [Comment] = []
        sut.fetchComments { result in
            switch result {
            case .success(let comments):
                capturedComments = comments
            case .failure(let error):
                XCTFail("Expected success, but got error instead, with error: \(error)")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertTrue(capturedComments.isEmpty)
    }
    
    func test_fetchComments_deliversItems() {
        let sut = makeSUT()
        let url = makeAnyURL()
        let response = makeHTTPURLResponse(url: url, statusCode: 200)
        let data = loadJSONData(forResource: "comments-response", extensionName: "json")
        
        URLProtocolStub.stub(httpURLResponse: response, data: data)
        
        let exp = expectation(description: "wait for request")
        var capturedComments: [Comment] = []
        sut.fetchComments { result in
            switch result {
            case .success(let comments):
                capturedComments = comments
            case .failure(let error):
                XCTFail("Expected success, but got error instead, with error: \(error)")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        let expectedComments = [
            Comment(
                postID: 1,
                id: 1,
                name: "id labore ex et quam laborum",
                email: "Eliseo@gardner.biz",
                body: "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"
            ),
            Comment(
                postID: 1,
                id: 2,
                name: "quo vero reiciendis velit similique earum",
                email: "Jayne_Kuhic@sydney.com",
                body: "est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et"
            )
        ]
        
        XCTAssertEqual(capturedComments, expectedComments)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> DefaultCommentsService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = DefaultCommentsService(session: session)
        return sut
    }
    
    private func makeAnyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
    
    private func makeHTTPURLResponse(url: URL, statusCode: Int) -> HTTPURLResponse {
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func loadJSONData(forResource resource: String, extensionName: String) -> Data {
        let bundle = Bundle(for: DefaultCommentsServiceTests.self)
        let resourceURL = bundle.url(forResource: resource, withExtension: extensionName)!
        let data = try! Data(contentsOf: resourceURL)
        return data
    }
    
}
