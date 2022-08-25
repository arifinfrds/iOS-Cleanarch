//
//  UserService.swift
//  CleanarchCore
//
//  Created by Arifin Firdaus on 11/10/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

enum LoadUserError: Error, Equatable {
    case invalidUserId
    case invalidBundleUrl
    case failToMakeDataOrDecodeUserData
}

class UserServiceImpl: UserService {
    
    public init() { }
    
    func fetchUsers(completion: @escaping (Result<[User], LoadUsersError>) -> Void) {
        completion(.success([]))
    }
    
    func fetchUser(id: Int, completion: @escaping ((Result<User, LoadUserError>) -> Void)) {
        completion(.failure(.invalidUserId))
    }
}


// MARK: - Mock

class MockUserServiceImpl: UserService {
    enum ExpectedCase {
        case success
        case fail(error: LoadUsersError)
    }
    
    var expectedCase: ExpectedCase
    var bundle: Bundle
    
    init(bundle: Bundle = .init()) {
        self.bundle = bundle
        self.expectedCase = .success
    }
    
    init(expectedCase: ExpectedCase = .success, bundle: Bundle = .init()) {
        self.expectedCase = expectedCase
        self.bundle = bundle
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
            guard let url = bundle.url(forResource: "Users", withExtension: "json") else {
                completion(.failure(.invalidBundleUrl))
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let decodedUsers = try JSONDecoder().decode([User].self, from: data)
                completion(.success(decodedUsers))
            } catch(_) {
                completion(.failure(.failToMakeDataOrDecodeUsersData))
                return
            }
        }
    }
    
    func fetchUser(id: Int, completion: @escaping ((Result<User, LoadUserError>) -> Void)) {
        if id <= 0 {
            completion(.failure(.invalidUserId))
            return
        }
        
        guard let url = bundle.url(forResource: "User", withExtension: "json") else {
            completion(.failure(.invalidBundleUrl))
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decodedUser = try JSONDecoder().decode(User.self, from: data)
            completion(.success(decodedUser))
        } catch(_) {
            completion(.failure(.failToMakeDataOrDecodeUserData))
            return
        }
    }
}




