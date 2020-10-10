//
//  HTTPCode.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 10/10/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

public struct HTTPCode {
    public static let OK_200 = 200
    public static let EVENT_ALREADY_CREATED_201 = 201
    public static let PAYMENT_IS_CREATED = 201
    public static let NO_CONTENT_204 = 204
    public static let BAD_REQUEST_400 = 400
    public static let UNAUTHORIZED_401 = 401
    public static let FORBIDDEN_403 = 403
    public static let NOT_FOUND_404 = 404
    public static let SERVER_ERROR_500 = 500
    
    private init() { }
}

