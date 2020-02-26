//
//  ViewPostUseCase.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

protocol ViewPostUseCase {
    func execute(id: Int, completion: @escaping ((Result<Post, Error>) -> Void))
}

class ViewPostUseCaseImpl: ViewPostUseCase {
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
