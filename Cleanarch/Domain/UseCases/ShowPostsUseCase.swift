//
//  ShowPostsUseCase.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

protocol ShowPostsUseCase {
    func execute(completion: @escaping ((Result<[Post], Error>) -> Void))
}
