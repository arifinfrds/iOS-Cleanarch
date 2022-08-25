//
//  CommentService.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 25/08/22.
//  Copyright © 2022 arifinfrds. All rights reserved.
//

import Foundation

protocol CommentService {
    func fetchComments(postId: Int, completion: @escaping ((Result<[CommentResponseDTO], LoadCommentsError>) -> Void))
}
