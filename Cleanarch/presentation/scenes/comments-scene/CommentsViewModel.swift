//
//  CommentsViewModel.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/5/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

protocol CommentsViewModelOutput {
    var comments: Observable<[CommentResponseDTO]> { get }
    var error: Observable<CommentsViewModelError> { get }
    var loadingType: Observable<CommentsViewModelLoadingType> { get }
}

enum CommentsViewModelError {
    case none
    case error(String)
}

enum CommentsViewModelLoadingType {
    case none
    case fullScreen
}

class CommentsViewModel: CommentsViewModelOutput {
    var comments: Observable<[CommentResponseDTO]> = Observable([CommentResponseDTO]())
    var error: Observable<CommentsViewModelError> = Observable(.none)
    var loadingType: Observable<CommentsViewModelLoadingType> = Observable(.none)
    
    var postId: Observable<Int> = Observable(0)
    
    private var useCase: ViewCommentsUseCase
    
    init(useCase: ViewCommentsUseCase) {
        self.useCase = useCase
    }
    
    func fetchComments(postId: Int) {
        loadingType.value = .fullScreen
        error.value = .none
        
        useCase.execute(postId: postId) { result in
            switch result {
            case .success(let comments):
                self.comments.value = comments
            case .failure(let error):
                self.error.value = .error(error.localizedDescription)
            }
            
            self.loadingType.value = .none
        }
    }
}
