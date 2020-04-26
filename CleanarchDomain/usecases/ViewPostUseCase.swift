//
//  ViewPostUseCase.swift
//  CleanarchDomain
//
//  Created by Arifin Firdaus on 26/04/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

public protocol ViewPostUseCase {
    func execute(id: Int, completion: @escaping ((Result<Post, Error>) -> Void))
}

public final class ViewPostUseCaseImpl: ViewPostUseCase {
    private let postRepository: PostRepository
    
    public init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    public func execute(id: Int, completion: @escaping ((Result<Post, Error>) -> Void)) {
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
