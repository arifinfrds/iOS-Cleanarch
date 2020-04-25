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

class ViewCommentsUseCaseImpl: ViewCommentsUseCase {
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
