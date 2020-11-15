//
//  CommentsMapperTests.swift
//  CleanarchTests
//
//  Created by Arifin Firdaus on 15/11/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import XCTest
@testable import Cleanarch

struct CommentsMapper {
    static func map(_ data: Data) -> Result<[Comment], DefaultCommentsService.Error> {
        do {
            let items = try JSONDecoder().decode([Comment].self, from: data)
            return .success(items)
        } catch(let error) {
            return .failure(.decodeFail(message: error.localizedDescription))
        }
    }
}

class CommentsMapperTests: XCTestCase {
    
    func test_map_deliversDecodeError() {
        let invalidJSONData = "invalid-json-data".data(using: .utf8)!
        let completionResult = CommentsMapper.map(invalidJSONData)
        
        switch completionResult {
        case .failure(let error):
            XCTAssertEqual(error, .decodeFail(message: "The data couldn’t be read because it isn’t in the correct format."))
        default:
            XCTFail("expect failure, but got success instead.")
        }
    }
    
    func test_map_deliversEmptyItems() {
        let validJSONData = "[]".data(using: .utf8)!
        let completionResult = CommentsMapper.map(validJSONData)
        
        switch completionResult {
        case .success(let comments):
            XCTAssertTrue(comments.isEmpty)
        case .failure(let error):
            XCTFail("expect success, but got failure instead with error: \(error)")
        }
    }
    
    func test_map_deliversItems() {
        let validJSONData = loadJSONData(forResource: "comments-response", extensionName: "json")
        let completionResult = CommentsMapper.map(validJSONData)
        
        switch completionResult {
        case .success(let comments):
            XCTAssertEqual(comments, makeExpectedComments())
        case .failure(let error):
            XCTFail("expect success, but got failure instead with error: \(error)")
        }
    }
    
    
    // MARK: - Helpers
    
    private func loadJSONData(forResource resource: String, extensionName: String) -> Data {
        let bundle = Bundle(for: CommentsMapperTests.self)
        let resourceURL = bundle.url(forResource: resource, withExtension: extensionName)!
        let data = try! Data(contentsOf: resourceURL)
        return data
    }
    
    private func makeExpectedComments() -> [Comment] {
        return [
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
    }
    
}
