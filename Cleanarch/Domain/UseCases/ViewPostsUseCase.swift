//
//  ViewPostsUseCase.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

protocol ViewPostsUseCase {
    func execute(completion: @escaping ((Result<[Post], Error>) -> Void))
}

class ViewPostsUseCaseImpl: ViewPostsUseCase {
    private let repository: PostRepository
    
    init(repository: PostRepository) {
        self.repository = repository
    }
    
    func execute(completion: @escaping ((Result<[Post], Error>) -> Void)) {
        repository.fetchPosts { result in
            switch result {
            case .success(let posts):
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
