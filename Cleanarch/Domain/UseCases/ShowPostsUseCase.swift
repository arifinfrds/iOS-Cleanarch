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

class ShowPostsUseCaseImpl: ShowPostsUseCase {
    
    private let postRepository: PostRepository?

    init(repository: PostRepository) {
        self.postRepository = repository
    }
    
    func execute(completion: @escaping ((Result<[Post], Error>) -> Void)) {
        postRepository?.fetchPosts(completion: { result in
            switch result {
            case .success(let posts):
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
