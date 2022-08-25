//
//  CommentModuleDIContainer.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 26/04/20.
//  Copyright © 2020 arifinfrds. All rights reserved.
//

import Foundation

final class CommentModuleDIContainer {
    struct Dependency {
        let commentService: CommentService
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func makeCommentsViewModel() -> CommentsViewModel {
        let service: CommentService = RemoteCommentService()
        let useCase: ViewCommentsUseCase = ViewCommentsUseCaseImpl(service: service)
        let viewModel = CommentsViewModel(useCase: useCase)
        return viewModel
    }
}

