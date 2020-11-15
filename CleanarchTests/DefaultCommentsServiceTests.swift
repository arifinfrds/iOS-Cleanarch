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
    
    func fetchComments(completion: @escaping (Result<[CommentResponseDTO], Error>) -> Void) {
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
                let completionResult = CommentsMapper.map(httpResponse, data!)
                completion(completionResult)
                return
            }
            fatalError("Unahndled case yet.")
        }.resume()
    }
}



class URLProtocolStub: URLProtocol {
    private struct Stub {
        let response: URLResponse?
        let data: Data?
        let error: Error?
    }
    
    private static var stub: Stub?
    
    static func stub(response: URLResponse?, data: Data?, error: Error?) {
        stub = Stub(response: response, data: data, error: error)
    }
    
    static func clear() {
        self.stub = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = URLProtocolStub.stub?.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        if let data = URLProtocolStub.stub?.data {
            self.client?.urlProtocol(self, didLoad: data)
        }
        if let response = URLProtocolStub.stub?.response {
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
        URLProtocolStub.stub(response: nil, data: nil, error: error)
        
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
        URLProtocolStub.clear()

        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_fetchComments_deliversInvalidDataError() {
        let sut = makeSUT()
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotParseResponse)
        URLProtocolStub.stub(response: nil, data: nil, error: error)
        
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
        URLProtocolStub.clear()
        
        XCTAssertEqual(capturedErrors, [.invalidData])
    }
    
    func test_fetchComments_deliversServerError() {
        let sut = makeSUT()
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse)
        URLProtocolStub.stub(response: nil, data: nil, error: error)
        
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
        URLProtocolStub.clear()
        
        XCTAssertEqual(capturedErrors, [.serverError])
    }
    
    func test_fetchComments_deliversInvalidParsingData() {
        let sut = makeSUT()
        let invalidJSONData = "an-invalid-json".data(using: .utf8)!
        let response = HTTPURLResponse(url: makeAnyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
        URLProtocolStub.stub(response: response, data: invalidJSONData, error: nil)
        
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
        URLProtocolStub.clear()
        
        XCTAssertEqual(capturedErrors, [.invalidData])
    }
    
    func test_fetchComments_deliversEmptyItems() {
        let sut = makeSUT()
        let url = makeAnyURL()
        let response = makeHTTPURLResponse(url: url, statusCode: 200)
        let data = "[]".data(using: .utf8)!
        
        URLProtocolStub.stub(response: response, data: data, error: nil)
        
        let exp = expectation(description: "wait for request")
        var capturedComments: [CommentResponseDTO] = []
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
        URLProtocolStub.clear()
        
        XCTAssertTrue(capturedComments.isEmpty)
    }
    
    func test_fetchComments_deliversItems() {
        let sut = makeSUT()
        let url = makeAnyURL()
        let response = makeHTTPURLResponse(url: url, statusCode: 200)
        let data = loadJSONData(forResource: "comments-response", extensionName: "json")
        
        URLProtocolStub.stub(response: response, data: data, error: nil)
        
        let exp = expectation(description: "wait for request")
        var capturedComments: [CommentResponseDTO] = []
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
            CommentResponseDTO(
                postID: 1,
                id: 1,
                name: "id labore ex et quam laborum",
                email: "Eliseo@gardner.biz",
                body: "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"
            ),
            CommentResponseDTO(
                postID: 1,
                id: 2,
                name: "quo vero reiciendis velit similique earum",
                email: "Jayne_Kuhic@sydney.com",
                body: "est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et"
            )
        ]
        URLProtocolStub.clear()
        
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
