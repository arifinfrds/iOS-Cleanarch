//
//  ViewPostUseCase.swift
//  CleanarchDomain
//
//  Created by Arifin Firdaus on 26/04/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

protocol ViewPostUseCase {
    func execute(id: Int, completion: @escaping ((Result<Post, Error>) -> Void))
}

final class ViewPostUseCaseImpl: ViewPostUseCase {
    private let service: PostService
    
    init(service: PostService) {
        self.service = service
    }
    
    func execute(id: Int, completion: @escaping ((Result<Post, Error>) -> Void)) {
        service.fetchPost(id: id) { result in
            switch result {
            case .success(let post):
                completion(.success(post))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
