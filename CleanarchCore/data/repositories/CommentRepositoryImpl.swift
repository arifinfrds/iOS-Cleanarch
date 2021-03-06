//
//  CommentRepositoryImpl.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/29/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

class CommentRepositoryImpl: CommentRepository {
    private var service: CommentService?
    
    init(service: CommentService) {
        self.service = service
    }
    
    func fetchComments(postId: Int, completion: @escaping ((Result<[CommentResponseDTO], LoadCommentsError>) -> Void)) {
        service?.fetchComments(postId: postId, completion: { result in
            switch result {
            case .success(let comments):
                completion(.success(comments))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
