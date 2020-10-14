//
//  UserRepositoryImpl.swift
//  CleanarchCore
//
//  Created by Arifin Firdaus on 14/10/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

public class UserRepositoryImpl: UserRepository {
    private let service: UserService
    
    public init(service: UserService) {
        self.service = service
    }
    
    public func fetchUsers(completion: @escaping (Result<[User], LoadUsersError>) -> Void) {
        service.fetchUsers { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
