//
//  ShowPostUseCaseImpl.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/4/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

class ShowPostUseCaseImpl: ShowPostUseCase {
    
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    func execute(id: Int, completion: @escaping ((Result<Post, Error>) -> Void)) {
        postRepository.fetchPost(id: id) { result in
            switch result {
            case .success(let post):
                completion(.success(post))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
