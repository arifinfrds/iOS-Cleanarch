//
//  ShowCommentsUseCaseImpl.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/4/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

class ShowCommentsUseCaseImpl: ShowCommentsUseCase {
    
    private var repository: CommentRepository?
    
    init(repository: CommentRepository) {
        self.repository = repository
    }
    
    func execute(postId: Int, completion: @escaping ((Result<[Comment], Error>) -> Void)) {
        repository?.fetchComments(postId: postId, completion: { result in
            switch result {
            case .success(let comments):
                completion(.success(comments))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
