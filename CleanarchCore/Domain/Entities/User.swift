//
//  User.swift
//  CleanarchDomain
//
//  Created by Arifin Firdaus on 11/10/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

// MARK: - User
struct User: Codable, Equatable {
    let id: Int?
    let name: String?
    let username: String?
    let email: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case username = "username"
        case email = "email"
    }
}
