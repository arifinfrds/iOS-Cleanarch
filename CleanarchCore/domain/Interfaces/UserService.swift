//
//  UserService.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 25/08/22.
//  Copyright © 2022 arifinfrds. All rights reserved.
//

import Foundation

protocol UserService {
    func fetchUsers(completion: @escaping (Result<[User], LoadUsersError>) -> Void)
    func fetchUser(id: Int, completion: @escaping ((Result<User, LoadUserError>) -> Void))
}
