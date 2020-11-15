//
//  UserRepositoryImpl.swift
//  CleanarchCore
//
//  Created by Arifin Firdaus on 14/10/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

class UserRepositoryImpl: UserRepository {
    private let service: UserService
    
    init(service: UserService) {
        self.service = service
    }
    
    func fetchUsers(completion: @escaping (Result<[User], LoadUsersError>) -> Void) {
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
