//
//  Comment.swift
//  CleanarchDomain
//
//  Created by Arifin Firdaus on 26/04/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

public struct Comment: Codable {
    public var postID: Int?
    public var id: Int?
    public var name: String?
    public var email: String?
    public var body: String?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id = "id"
        case name = "name"
        case email = "email"
        case body = "body"
    }
}
