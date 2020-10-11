//
//  User.swift
//  CleanarchDomain
//
//  Created by Arifin Firdaus on 11/10/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

// MARK: - User
public struct User: Codable {
    public let id: Int?
    public let name: String?
    public let username: String?
    public let email: String?
    public let address: Address?
    public let phone: String?
    public let website: String?
    public let company: Company?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case username = "username"
        case email = "email"
        case address = "address"
        case phone = "phone"
        case website = "website"
        case company = "company"
    }
}

// MARK: - Address
public struct Address: Codable {
    public let street: String?
    public let suite: String?
    public let city: String?
    public let zipcode: String?
    public let geo: Geo?

    enum CodingKeys: String, CodingKey {
        case street = "street"
        case suite = "suite"
        case city = "city"
        case zipcode = "zipcode"
        case geo = "geo"
    }
}

// MARK: - Geo
public struct Geo: Codable {
    public let lat: String?
    public let lng: String?

    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
}

// MARK: - Company
public struct Company: Codable {
    public let name: String?
    public let catchPhrase: String?
    public let bs: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case catchPhrase = "catchPhrase"
        case bs = "bs"
    }
}

