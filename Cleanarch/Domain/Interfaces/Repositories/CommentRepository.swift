//
//  CommentRepository.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/18/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

protocol CommentRepository {
    func fetchComments(postId: Int, completion: @escaping ((Result<[Comment], Error>) -> Void))
}
