//
//  CommentService.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/29/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import Foundation
import CleanarchDomain


protocol CommentService {
    func fetchComments(postId: Int, completion: @escaping ((Result<[Comment], LoadCommentsError>) -> Void))
}

class CommentServiceImpl: CommentService {
    
    init() { }
    
    func fetchComments(postId: Int, completion: @escaping ((Result<[Comment], LoadCommentsError>) -> Void)) {
        if postId < 0 {
            completion(.failure(.invalidPostId))
            return
        }
        let urlString = "https://jsonplaceholder.typicode.com/comments?postId=\(postId)"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, urlResponse, error) in
            if let error = error {
                completion(.failure(.unknown(message: error.localizedDescription)))
                return
            }
            guard let data = data else {
                completion(.failure(.unknown(message: "Data is null from response")))
                return
            }
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                completion(.failure(.unknown(message: "Cannot get HTTPResponse")))
                return
            }
            if httpResponse.statusCode == HTTPCode.OK_200 {
                do {
                    let comments = try JSON().newJSONDecoder().decode([Comment].self, from: data)
                    completion(.success(comments))
                } catch(let error) {
                    completion(.failure(.unknown(message: error.localizedDescription)))
                }
            }
        }.resume()
    }
}
