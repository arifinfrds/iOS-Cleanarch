//
//  ShowCommentsUseCase.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/29/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

protocol ShowCommentsUseCase {
    func execute(postId: Int, completion: ((Result<[Comment], Error>) -> Void))
}

class ShowCommentsUseCaseImpl: ShowCommentsUseCase {
    
    private var repository: CommentRepository?
    
    init(repository: CommentRepository) {
        self.repository = repository
    }
    
    func execute(postId: Int, completion: ((Result<[Comment], Error>) -> Void)) {
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
