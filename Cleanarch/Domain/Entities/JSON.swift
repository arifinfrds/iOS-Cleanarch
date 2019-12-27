//
//  JSON.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/27/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

class JSON<T> where T : Codable {
    
    private var codable: T?
    
    func getCodable() -> T? {
        return codable
    }
    
    init(data: Data) throws {
        self.codable = try newJSONDecoder().decode(T.Type, from: data)
    }
    
    func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        }
        return encoder
    }
}
