//
//  ViewCommentsUseCase.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/29/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

protocol ViewCommentsUseCase {
    func execute(postId: Int, completion: @escaping ((Result<[Comment], Error>) -> Void))
}
