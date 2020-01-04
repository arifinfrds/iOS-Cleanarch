//
//  ShowPostUseCase.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

protocol ShowPostUseCase {
    func execute(id: Int, completion: @escaping ((Result<Post, Error>) -> Void))
}
