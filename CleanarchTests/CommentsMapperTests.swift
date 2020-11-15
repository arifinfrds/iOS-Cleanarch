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
    
    func test_Map_deliversEmptyItems() {
        let validJSONData = "[]".data(using: .utf8)!
        let completionResult = CommentsMapper.map(validJSONData)
        
        switch completionResult {
        case .success(let comments):
            XCTAssertTrue(comments.isEmpty)
        case .failure(let error):
            XCTFail("expect success, but got failure instead with error: \(error)")
        }
    }

}
