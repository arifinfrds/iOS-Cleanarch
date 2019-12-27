//
//  Post.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

struct Post: Codable {
    
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
    
    var json: JSON<Post>?
    
    init(data: Data) throws {
        json = try JSON(data: data)
        
        guard let codable = json?.getCodable() else { return }
        self = codable
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case id = "id"
        case title = "title"
        case body = "body"
    }
  
}
