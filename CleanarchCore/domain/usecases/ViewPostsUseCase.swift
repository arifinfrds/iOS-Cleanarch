//
//  ViewPostsUseCase.swift
//  CleanarchDomain
//
//  Created by Arifin Firdaus on 26/04/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

protocol ViewPostsUseCase {
    func execute(completion: @escaping ((Result<[Post], Error>) -> Void))
}

final class ViewPostsUseCaseImpl: ViewPostsUseCase {
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
