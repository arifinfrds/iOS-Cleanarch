//
//  CommentRepository.swift
//  CleanarchDomain
//
//  Created by Arifin Firdaus on 26/04/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

protocol CommentRepository {
    func fetchComments(postId: Int, completion: @escaping ((Result<[CommentResponseDTO], LoadCommentsError>) -> Void))
}
