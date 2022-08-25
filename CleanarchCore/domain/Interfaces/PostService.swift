//
//  PostService.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 25/08/22.
//  Copyright © 2022 arifinfrds. All rights reserved.
//

import Foundation

protocol PostService {
    func fetchPosts(completion: @escaping ((Result<[Post], Error>) -> Void))
    func fetchPost(id: Int, completion: @escaping ((Result<Post, Error>) -> Void))
}

