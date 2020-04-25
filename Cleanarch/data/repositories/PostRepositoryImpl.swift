//
//  PostRepositoryImpl.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

class PostRepositoryImpl: PostRepository {
    
    private var postService: PostService
    
    init(postService: PostService) {
        self.postService = postService
    }
    
    func fetchPosts(completion: @escaping ((Result<[Post], Error>) -> Void)) {
        postService.fetchPosts { result in
            switch result {
            case .success(let posts):
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPost(id: Int, completion: @escaping ((Result<Post, Error>) -> Void)) {
        postService.fetchPost(id: id) { result in
            switch result {
            case .success(let post):
                completion(.success(post))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
