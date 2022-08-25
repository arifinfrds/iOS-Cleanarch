//
//  ViewCommentsUseCase.swift
//  CleanarchDomain
//
//  Created by Arifin Firdaus on 26/04/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

enum LoadCommentsError: Error, Equatable {
    case invalidPostId
    case invalidURL
    case unknown(message: String)
}

protocol ViewCommentsUseCase {
    func execute(postId: Int, completion: @escaping ((Result<[CommentResponseDTO], LoadCommentsError>) -> Void))
}

final class ViewCommentsUseCaseImpl: ViewCommentsUseCase {
    private var service: CommentService
    
    init(service: CommentService) {
        self.service = service
    }
    
    func execute(postId: Int, completion: @escaping ((Result<[CommentResponseDTO], LoadCommentsError>) -> Void)) {
        service.fetchComments(postId: postId, completion: { result in
            switch result {
            case .success(let comments):
                completion(.success(comments))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

