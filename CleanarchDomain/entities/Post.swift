//
//  Post.swift
//  CleanarchDomain
//
//  Created by Arifin Firdaus on 26/04/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

public struct Post: Codable {
    public var userId: Int?
    public var id: Int?
    public var title: String?
    public var body: String?
 
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case id = "id"
        case title = "title"
        case body = "body"
    }
    
    public init() { }
  
}
