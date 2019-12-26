//
//  ShowPostUseCase.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

// TODO: - Next
protocol ShowPostUseCase {
    func execute(completion: ((Result<Post, Error>) -> Void))
}

class ShowPostUseCaseImpl: ShowPostUseCase {
    
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    func execute(completion: ((Result<Post, Error>) -> Void)) {
       
    }
}
