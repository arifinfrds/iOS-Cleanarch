//
//  LoadUsersUseCase.swift
//  CleanarchCore
//
//  Created by Arifin Firdaus on 14/10/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

enum LoadUsersError: Error, Equatable {
    case invalidToken
    case invalidURL
    case serverError
    case noInternetConnection
    case invalidBundleUrl
    case failToMakeDataOrDecodeUsersData
    case unknown(message: String)
}

protocol LoadUsersUseCase {
    func execute(completion: @escaping (Result<[User], LoadUsersError>) -> Void)
}

class LoadUsersUseCaseImpl: LoadUsersUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result<[User], LoadUsersError>) -> Void) {
        repository.fetchUsers { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


