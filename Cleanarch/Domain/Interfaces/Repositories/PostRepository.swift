//
//  PostRepository.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/18/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

protocol PostRepository {
    func fetchPosts(completion: @escaping ((Result<[Post], Error>) -> Void))
    func fetchPost(id: Int, completion: @escaping ((Result<Post, Error>) -> Void))
}
