//
//  PostService.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/26/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation

protocol PostService {
    func fetchPosts(completion: @escaping ((Result<[Post], Error>) -> Void))
    func fetchPost(id: Int, completion: @escaping ((Result<Post, Error>) -> Void))
}

class PostServiceImpl: PostService {
    
    func fetchPosts(completion: @escaping ((Result<[Post], Error>) -> Void)) {
        let urlString = "https://jsonplaceholder.typicode.com/posts/"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, urlResponse, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let posts = try newJSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))
            } catch(let error) {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPost(id: Int, completion: @escaping ((Result<Post, Error>) -> Void)) {
        let urlString = "https://jsonplaceholder.typicode.com/posts/\(id)"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, urlResponse, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let posts = try newJSONDecoder().decode(Post.self, from: data)
                completion(.success(posts))
            } catch(let error) {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
