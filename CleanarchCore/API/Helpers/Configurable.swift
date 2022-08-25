//
//  Configurable.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 11/10/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

public protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

struct MockNetworkConfigurableImpl: NetworkConfigurable {
    var baseURL: URL = URL(string: "a-given-url")!
    var headers: [String : String] = [:]
    var queryParameters: [String : String] = [:]
}

protocol SessionManager {
    
}
