//
//  UserService.swift
//  CleanarchCore
//
//  Created by Arifin Firdaus on 11/10/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

public enum LoadUsersError: Error, Equatable {
    case invalidToken
    case invalidURL
    case serverError
    case noInternetConnection
    case unknown(message: String)
}

public protocol UserService {
    func fetchUsers(completion: @escaping (Result<[User], LoadUsersError>) -> Void)
}

class UserServiceImplMock: UserService {
    enum ExpectedCase {
        case success
        case fail(error: LoadUsersError)
    }
    
    var expectedCase: ExpectedCase
    
    init(expectedCase: ExpectedCase) {
        self.expectedCase = expectedCase
    }
    
    func fetchUsers(completion: @escaping (Result<[User], LoadUsersError>) -> Void) {
        switch expectedCase {
        case .fail(let error):
            if error == .noInternetConnection {
                completion(.failure(.noInternetConnection))
                return
            }
            if error == .serverError {
                completion(.failure(.serverError))
                return
            }
            if error == .invalidToken {
                completion(.failure(.invalidToken))
                return
            }
            if error == .invalidURL {
                completion(.failure(.invalidURL))
                return
            }
        case .success:
            let decodedUsers = [
                User(id: 1,
                     name: "Arifin Firdaus",
                     username: "arifinfrds",
                     email: nil
                )
            ]
            completion(.success(decodedUsers))
        }
    }
}




