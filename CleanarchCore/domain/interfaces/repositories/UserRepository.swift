//
//  UserRepository.swift
//  CleanarchCore
//
//  Created by Arifin Firdaus on 14/10/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

protocol UserRepository {
    func fetchUsers(completion: @escaping (Result<[User], LoadUsersError>) -> Void)
}
