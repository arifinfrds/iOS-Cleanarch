//
//  ShowPostUseCaseImpl.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/4/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

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
