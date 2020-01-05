//
//  CommentsViewModel.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 1/5/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

protocol CommentsViewModelOutput {
    var comments: Observable<[Comment]> { get }
    var error: Observable<String> { get }
}

class CommentsViewModel: CommentsViewModelOutput {
    var comments: Observable<[Comment]> = Observable([Comment]())
    var error: Observable<String> = Observable("")
    var loadingType: Observable<CommentsLoadingType> = Observable(.none)
    
    enum CommentsLoadingType {
        case none
        case fullScreen
    }
    
    private var useCase: ShowCommentsUseCase
    
    init(useCase: ShowCommentsUseCase) {
        self.useCase = useCase
    }
    
    func fetchComments(postId: Int) {
        loadingType.value = .none
        
        useCase.execute(postId: postId) { result in
            switch result {
            case .success(let comments):
                self.comments.value = comments
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
            
            self.loadingType.value = .none
        }
    }
}
