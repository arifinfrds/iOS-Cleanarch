//
//  User.swift
//  CleanarchDomain
//
//  Created by Arifin Firdaus on 11/10/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

// MARK: - User
public struct User: Codable, Equatable {
    public let id: Int?
    public let name: String?
    public let username: String?
    public let email: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case username = "username"
        case email = "email"
    }
    
    public init(id: Int?, name: String?, username: String?, email: String?) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
    }
}
